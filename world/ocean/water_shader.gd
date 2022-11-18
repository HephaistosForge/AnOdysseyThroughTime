extends MeshInstance3D


func _ready():
	mesh.material.set_shader_parameter("center", position)


func _enable_waves() -> void:
	mesh.material.set_shader_parameter("height_scale", 1.0)
	position.y = -0.5


func _disable_waves() -> void:
	mesh.material.set_shader_parameter("height_scale", 0.0)
	position.y = 0


func _enable_dark_water() -> void:
	var new_water_color = Vector3(0.01, 0.03, 0.05)
	mesh.material.set_shader_parameter("water_color", new_water_color)


func _enable_bright_water() -> void:
	var new_water_color = Vector3(0.1, 0.3, 0.5)
	mesh.material.set_shader_parameter("water_color", new_water_color)


func _set_water_color(r: float, g: float, b: float) -> void:
	var new_water_color = Vector3(r, g, b)
	mesh.material.set_shader_parameter("water_color", new_water_color)
