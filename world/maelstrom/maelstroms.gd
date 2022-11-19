extends MeshInstance3D

@export var maelstroms: Array[Vector3]

var mesh_size
func _ready():
	for i in 10:
		maelstroms.append(Vector3(randf(), randf(), randf()))
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
			force += diff / pow(dist, 2)
		print(force)
		object.velocity += force * 10
