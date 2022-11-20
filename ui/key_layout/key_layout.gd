extends Control

func _on_button_pressed():
	assert(get_tree().change_scene_to_file("res://ui/options/options.tscn") == 0)
