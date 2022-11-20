extends PanelContainer

func _on_play_pressed():
	assert(get_tree().change_scene_to_file("res://world/ocean/ocean.tscn") == 0)
	
func _on_highscore_pressed():
	assert(get_tree().change_scene_to_file("res://ui/highscore/highscore.tscn") == 0)

func _on_options_pressed():
	assert(get_tree().change_scene_to_file("res://ui/options/options.tscn") == 0)

func _on_exit_pressed():
	get_tree().quit()
