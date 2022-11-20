extends Node

var rng
var score: int = 0
var start_pos = Vector3.ZERO
var map_size = Vector2(1800, 1800)

var enable_good_graphics: bool = false


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()



func reset_score():
	score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
