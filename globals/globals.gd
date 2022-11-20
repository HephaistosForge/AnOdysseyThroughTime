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


func _process(_delta):
	if Input.is_action_just_pressed("toggle_mute"):
		print("toggle mute")
		_toggle_global_sound()


func _toggle_global_sound() -> void:
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
	else:
		AudioServer.set_bus_mute(0, true)
