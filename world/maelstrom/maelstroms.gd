extends MeshInstance3D

const AREA_PREFAB: PackedScene = preload("res://world/maelstrom/maelstrom_area.tscn")

@export var maelstroms: Array[Vector3]
@export var water_height: Texture2D

var material = preload("res://world/ocean/water_height.tres")

var spawn_point_as_uv = Vector3(0.5, 0.5, 0)
var mesh_size = 1800

var ship
var depth_image = null
@onready var ___shader_container = get_parent().get_node("SubViewport/TextureRect")

func uv_to_world(pos):
	return Vector3(pos.x-0.5, 0, pos.y-.5) * mesh_size

func world_to_uv(pos):
	return Vector3(pos.x/mesh_size + 0.5, pos.z/mesh_size + 0.5, 0.2)

func _ready():
	var island = get_tree().get_first_node_in_group("island")
	var island_as_uv = world_to_uv(island.position)
	
	mesh_size = mesh.size.x
	if Globals.start_pos != Vector3.ZERO:
		spawn_point_as_uv = world_to_uv(Globals.start_pos)
		
	#for maelstrom in $Maelstroms.get_children():
	#	maelstroms.append(world_to_uv(maelstrom.position))
	
	var pos;
	for i in 50:
		var trials = 0
		while true:
			pos = Vector3(randf(), randf(), .2)
			if pos.distance_to(spawn_point_as_uv) > 0.045 and pos.distance_to(island_as_uv) > 0.05:
				if trials < 10:
					for p in maelstroms:
						if pos.distance_to(p) < 0.1:
							trials += 1
							continue
				break
		maelstroms.append(pos)
	
	for i in len(maelstroms):
		#mesh.material.set_shader_parameter("maelstrom_positions" + str(i), maelstroms[i])
		var area = AREA_PREFAB.instantiate()
		add_child(area)
		area.position = uv_to_world(maelstroms[i])
		
		
var time = 0
func _process(delta):
	# shader_mat.set_uniform_value("time", time)
	time += delta
	
	var best = []
	
	ship = get_tree().get_first_node_in_group("boat")
	var pos = ship.position
	for m in maelstroms:
		var dist = pos-uv_to_world(m)
		dist = dist.length()
		best.append([dist, m])
	
	best.sort()
	best = best.slice(0,15)
	
	for i in len(best):
		mesh.material.set_shader_parameter("maelstrom_positions" + str(i), best[i][1])
		___shader_container.material.set_shader_parameter("maelstrom_positions" + str(i), best[i][1])
	#occ(get_parent().get_node("SubViewport").get_texture().get_image().get_data())
	#occ(get_parent().get_node("SubViewport/Sprite2D").get_texture().get_image().get_data())

func occ(data):
	var occu = {}
	for val in data:
		if val not in occu:
			occu[val] = 0
		occu[val] += 1
	print(occu)
		
func height(uv):
	var h = sin(time * 1.0 + uv.x*100. + uv.y*120.)
	h += sin(time * 0.5 + uv.x*80. + uv.y*20. )
	return h

var time_i = 0

func _physics_process(_delta):
	for object in get_tree().get_nodes_in_group("pullable"):
		var force = Vector3.ZERO
		for maelstrom in maelstroms:
			var pos = Vector3(maelstrom.x-0.5, 0, maelstrom.y-.5) * mesh_size
			var diff = (pos - object.position)*Vector3(1,0,1)
			var dist = diff.length()
			if object is RigidBody3D:
				force += diff / pow(dist, 3)
			else:
				force += diff / pow(dist, 2.5)
			
		if object is RigidBody3D:
			object.apply_force(force * 10000 * 40)
		else:
			object.velocity += force * 65
	# time_i += 1

	#for y in img.MAX_HEIGHT:
	#	for x in img.MAX_WIDTH:
	#		print(img.get_pixel(x, y))
	if depth_image != null:
		for object in get_tree().get_nodes_in_group("pullable"):
			# img.lock()
			var px = (object.position.x+mesh_size/2.0) /mesh_size * 512
			var py = (object.position.z+mesh_size/2.0) / mesh_size * 512
			px = clamp(px, 0, 511)
			py = clamp(py, 0, 511)
			var h = depth_image.get_pixel(px, py)
			if object.is_in_group("boat"):
				#print([px, py], h)
				var new_pos = h.r * 45 - 45
				object.position.y += (new_pos - object.position.y) / 7
		
#	for object in get_tree().get_nodes_in_group("pullable"):
#		object.position.y = -height(object.position / 512 + Vector3(0.5, 0.5, 0.5))
#		for maelstrom in maelstroms:
#			var pos = Vector3(maelstrom.x-0.5, 0, maelstrom.y-.5) * mesh_size
#			var diff = pos - object.position
#			var dist = diff.length()
#			object.position.y -= 10000 / max(100, pow(dist, 2))
	#if time_i % 3 == 0:
		
		#var img = get_parent().get_node("Sprite2D").get_texture().get_image().get_data().duplicate()
		#occ(img)
	depth_image = await try()

func try():
	var ___drawer = get_parent().get_node("Sprite2D")

	var ___viewport = get_parent().get_node("SubViewport")
	var resolution = Vector2(512, 512)
	___viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	# ###
	var ___generated_image
	___viewport.size = resolution
	# ___viewport.render_target_update_mode = Viewport
	___shader_container.size = resolution
	
	# Set material type
	#___shader_container.set_material(material)
	
	# Set shaders param
	#___shader_container.get_material().set_shader_param("resolution", resolution)
	#for arg in args:
	#	___shader_container.get_material().set_shader_param(arg, args[arg])
	
	## Actually Generate Image
	___drawer.show()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	if is_instance_valid(self):
		___generated_image = ___drawer.get_texture().get_image().duplicate()
		# emit_signal("generated")
		___viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
		___drawer.hide()
		return ___generated_image

