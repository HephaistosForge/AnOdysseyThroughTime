extends WorldEnvironment


func _ready():
	print(Globals.enable_good_graphics)
	if Globals.enable_good_graphics:
		self.environment.ssao_enabled = true
		self.environment.ssr_enabled = true
		self.environment.ssil_enabled = true
		
		var directional_light = get_parent().get_node("DirectionalLight3D")
		directional_light.shadow_enabled = true
