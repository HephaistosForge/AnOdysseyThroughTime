extends PanelContainer

func _on_play_button_pressed():
	assert(get_tree().change_scene_to_file("res://world/ocean/ocean_spawning.tscn") == 0)

func _on_menu_button_pressed():
	assert(get_tree().change_scene_to_file("res://ui/menu/menu.tscn") == 0)
