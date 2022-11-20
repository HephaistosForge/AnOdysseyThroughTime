extends Node3D


var rmoved = false
var collected = false

@onready var area = $Area3D
@onready var score = get_tree().get_first_node_in_group("score_tracker")
@onready var model = $Model
@onready var animation_player = $Model/AnimationPlayer

const COIN_VALUE = 100

func _ready() -> void:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("boat"):
			collect()


func collect():
	self.collected = true
	animation_player.play("collect")
	score.add_score(COIN_VALUE)


func rm(_pos):
	if collected:
		return
	if rmoved:
		return
	else:
		rmoved = true
	
	var tween = create_tween()
	var _error = tween.tween_property(model, "scale", Vector3.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_error = tween.tween_callback(queue_free)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("boat"):
		collect()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "collect":
		self.queue_free()
