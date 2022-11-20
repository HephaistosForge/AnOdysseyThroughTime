extends PanelContainer

func _on_steuerung_pressed():
	assert(get_tree().change_scene_to_file("res://ui/key_layout/key_layout.tscn") == 0)

func _on_back_button_pressed():
	assert(get_tree().change_scene_to_file("res://ui/menu/menu.tscn") == 0)
	
	if AudioServer.get_bus_volume_db(1) <= -41:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
	
	if AudioServer.get_bus_volume_db(2) <= -41:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
