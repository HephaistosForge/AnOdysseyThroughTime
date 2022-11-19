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
		
		
var time = 0
func _process(delta):
	# shader_mat.set_uniform_value("time", time)
	time += delta
		
func height(uv):
	var h = sin(time * 1.0 + uv.x*100. + uv.y*120.)
	h += sin(time * 0.5 + uv.x*80. + uv.y*20. )
	return h

		
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
			
	# var img = height_texture.get_image()
	#for y in img.MAX_HEIGHT:
	#	for x in img.MAX_WIDTH:
	#		print(img.get_pixel(x, y))
	for object in get_tree().get_nodes_in_group("pullable"):
		var px = int(object.position.x+256)
		var py = int(object.position.z+256)
		object.position.y = -height(object.position / 512 + Vector3(0.5, 0.5, 0.5))
		for maelstrom in maelstroms:
			var pos = Vector3(maelstrom.x-0.5, 0, maelstrom.y-.5) * mesh_size
			var diff = pos - object.position
			var dist = diff.length()
			object.position.y -= 10000 / max(100, pow(dist, 2))
		#if object.is_in_group("boat"):
		#	print(object.position)
		#print(object.position, img.get_pixel(px, py).b * 10)


