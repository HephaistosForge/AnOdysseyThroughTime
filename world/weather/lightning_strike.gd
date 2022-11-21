extends Node3D

@onready var ship_selection = get_tree().get_first_node_in_group("ship_selection")
@onready var lightning_strike_generator: Node3D = get_parent()
@onready var despawn_timer: Timer = $DespawnTimer
@onready var spawn_indicator: MeshInstance3D = $SpawnProgressIndicator
@onready var spawn_area_indicator: MeshInstance3D = $SpawnAreaIndicator
@onready var area3D = $Area3D
@onready var sprite = $Sprite3D
@export var despawn_time: float = 0.3

var spawn_time: float = 1.5
const INVULNERABILTY_TIME = 5.0

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false
	var tween = create_tween()
	var orig_scale = spawn_area_indicator.scale
	spawn_area_indicator.scale = Vector3.ZERO
	tween.tween_property(spawn_area_indicator, "scale", orig_scale, 1) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_ELASTIC)
	
	var _error = tween.parallel().tween_property(spawn_indicator, "scale", orig_scale, spawn_time-0.05)
	# _error = tween.tween_property(spawn_indicator, "visible", false, 0.05)
	# _error = tween.parallel().tween_property(spawn_area_indicator, "visible", false, 0.05)
	_error = tween.tween_property(spawn_area_indicator, "scale", Vector3.ZERO, 1) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_ELASTIC)
	_error = tween.parallel().tween_property(spawn_indicator, "scale", Vector3.ZERO, 1) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_ELASTIC)
	_error = tween.tween_callback(set_active)


func set_spawn_delay(_delay: float):
	spawn_time = _delay

func set_active():
	self.active = true
	sprite.visible = true
	despawn_timer.start(despawn_time)
	var bodies = area3D.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.is_in_group("boat"):
				_on_area_3d_body_entered(body)
	
	var lightning = $LightningStrikeSFX.duplicate()
	get_tree().get_root().add_child(lightning)
	lightning.global_position = self.global_position
	lightning.play()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if lightning_strike_generator.time_since_last_hit >= INVULNERABILTY_TIME:
		if active and body.is_in_group("boat"):
			lightning_strike_generator.on_hit()
			ship_selection.prompt_ui()
		active = false


func _on_despawn_timer_timeout() -> void:
	self.queue_free()



