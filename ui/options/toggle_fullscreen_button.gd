extends MenuButton


func _ready():
	assert(self.get_popup().id_pressed.connect(_on_option_pressed) == 0)


func _on_option_pressed(id: int):
	match id:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		_:
			pass
