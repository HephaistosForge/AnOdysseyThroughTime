extends PanelContainer

@onready var score_label = $VBoxContainer/Score/VBoxContainer/score

func _ready():
	score_label.text = str(Globals.score)


func _on_play_button_pressed():
	Globals.reset_score()
	assert(get_tree().change_scene_to_file("res://world/ocean/ocean_spawning.tscn") == 0)

func _on_menu_button_pressed():
	Globals.reset_score()
	assert(get_tree().change_scene_to_file("res://ui/menu/menu.tscn") == 0)
