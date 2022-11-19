extends PanelContainer

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world/ocean/ocean.tscn")
	
func _on_highscore_pressed():
	get_tree().change_scene_to_file("res://ui/highscore/highscore.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://ui/options/options.tscn")

func _on_exit_pressed():
	get_tree().quit()
