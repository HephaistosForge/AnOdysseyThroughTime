extends MeshInstance3D

const AREA_PREFAB: PackedScene = preload("res://world/maelstrom/maelstrom_area.tscn")

@export var maelstroms: Array[Vector3]

var spawn_point_as_uv = Vector3(0.5, 0.5, 0)
var mesh_size = 1200

func uv_to_world(pos):
	return Vector3(pos.x-0.5, 0, pos.y-.5) * mesh_size

func world_to_uv(pos):
	return Vector3(pos.x/mesh_size + 0.5, pos.z/mesh_size + 0.5, 0.2)

func _ready():
	for maelstrom in $Maelstroms.get_children():
		maelstroms.append(world_to_uv(maelstrom.position))
	#var pos;
	#for i in 10:
	#	while true:
	#		pos = Vector3(randf(), randf(), .2)
	#		if pos.distance_to(spawn_point_as_uv) > .3:
	#			break
	for i in len(maelstroms):
		mesh.material.set_shader_parameter("maelstrom_positions" + str(i), maelstroms[i])
		mesh_size = mesh.size.x
		
		var area = AREA_PREFAB.instantiate()
		add_child(area)
		area.position = uv_to_world(maelstroms[i])
		
		
func _physics_process(_delta):
	for object in get_tree().get_nodes_in_group("pullable"):
		var force = Vector3.ZERO
		for maelstrom in maelstroms:
			var pos = Vector3(maelstrom.x-0.5, 0, maelstrom.y-.5) * mesh_size
			var diff = pos - object.position
			var dist = diff.length()
			force += diff / pow(dist, 3)
			
		if object is RigidBody3D:
			object.apply_force(force * 10000)
		else:
			object.velocity += force * 100

