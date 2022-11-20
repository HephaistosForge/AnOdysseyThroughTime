extends MarginContainer

@onready var value_label = $PanelContainer/MarginContainer/HBoxContainer/Value

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_score(_score: int):
	self.score += _score
	value_label = self.score
