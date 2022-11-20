extends MarginContainer

@onready var value_label = $PanelContainer/MarginContainer/HBoxContainer/Value

var score = 0

func add_score(_score: int):
	self.score += _score
	value_label.text = str(self.score)
