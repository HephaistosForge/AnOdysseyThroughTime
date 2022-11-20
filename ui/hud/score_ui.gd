extends MarginContainer

@onready var value_label = $PanelContainer/MarginContainer/HBoxContainer/Value

func add_score(_score: int):
	Globals.score += _score
	value_label.text = str(Globals.score)
