extends PanelContainer


@onready var high_score_container: VBoxContainer= $VBoxContainer/MarginContainer3/VBoxContainer
const main_theme = preload("res://ui/ui_theme.tres")

func _on_back_button_pressed():
	assert(get_tree().change_scene_to_file("res://ui/menu/menu.tscn") == 0)



func _ready():
	var highscores = LoadAndSave.game_data["highscore"]
	for score in highscores:
		add_high_score_item(score)


func add_high_score_item(score):
	var high_score_label = Label.new()
	high_score_label.text = str(score)
	high_score_label.theme = main_theme
	high_score_label.add_theme_font_size_override("Font Size", 24)
	high_score_container.add_child(high_score_label)
	
	
