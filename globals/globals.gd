extends Node

var menu_scene = preload("res://ui/menu/menu.tscn")

var rng
var score: int = 0
var start_pos = Vector3.ZERO
var map_size = Vector2(2500, 2500)

var enable_good_graphics: bool = false


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()


func reset_score():
	score = 0


func _process(_delta):
	if Input.is_action_just_pressed("toggle_mute"):
		_toggle_global_sound()
	if Input.is_action_just_pressed("escape"):
		var to_menu_confirm_dialog = get_tree().get_root().get_node("./ocean2/ToMenuConfirm")
		if to_menu_confirm_dialog:
			to_menu_confirm_dialog.visible = true
			get_tree().paused = true


func _change_to_menu() -> void:
	assert(get_tree().change_scene_to_packed(menu_scene) == 0)
	get_tree().paused = false


func _toggle_global_sound() -> void:
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
	else:
		AudioServer.set_bus_mute(0, true)
