extends Node

var rng
var start_pos = Vector3.ZERO
var map_size = Vector2(1800, 1800)

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
