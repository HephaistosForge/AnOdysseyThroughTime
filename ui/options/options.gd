extends PanelContainer

func _on_steuerung_pressed():
	assert(get_tree().change_scene_to_file("res://ui/key_layout/key_layout.tscn") == 0)

func _on_back_button_pressed():
	assert(get_tree().change_scene_to_file("res://ui/menu/menu.tscn") == 0)
