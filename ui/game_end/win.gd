extends PanelContainer

@onready var score_label = $VBoxContainer/Score/VBoxContainer/Label2
@onready var highscore_notification = $VBoxContainer/Score/VBoxContainer/Label3


func _ready():
	score_label.text = str(Globals.score)
	if LoadAndSave.check_for_new_highscore(Globals.score):
		highscore_notification.visible = true

func _on_play_button_pressed():
	Globals.reset_score()
	assert(get_tree().change_scene_to_file("res://world/ocean/ocean_spawning.tscn") == 0)

func _on_menu_button_pressed():
	Globals.reset_score()
	assert(get_tree().change_scene_to_file("res://ui/menu/menu.tscn") == 0)

