extends MeshInstance3D

@export var maelstroms: Array[Vector3]

var spawn_point_as_uv = Vector3(0.5, 0.5, 0)
var mesh_size

func _ready():
	var pos;
	for i in 10:
		while true:
			pos = Vector3(randf(), randf(), .2)
			if pos.distance_to(spawn_point_as_uv) > .3:
				break
		maelstroms.append(pos)
	for i in len(maelstroms):
		mesh.material.set_shader_parameter("maelstrom_positions" + str(i), maelstroms[i])
		mesh_size = mesh.size.x
 
func _physics_process(delta):
	for object in get_tree().get_nodes_in_group("pullable"):
		var force = Vector3.ZERO
		for maelstrom in maelstroms:
			var pos = Vector3(maelstrom.x-0.5, 0, maelstrom.y-.5) * mesh_size
			var diff = pos - object.position
			var dist = diff.length()
			force += diff / pow(dist, 3)
		object.velocity += force * 100
