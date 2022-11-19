extends Node3D

@onready var ship_selection = get_tree().get_first_node_in_group("ship_selection")
@onready var lightning_strike_generator: Node3D = get_parent()
@onready var despawn_timer: Timer = $DespawnTimer
@onready var spawn_indicator: MeshInstance3D = $SpawnProgressIndicator
@onready var spawn_area_indicator: MeshInstance3D = $SpawnAreaIndicator
@onready var area3D = $Area3D
@onready var sprite = $Sprite3D
@export var despawn_time: float = 0.3

var spawn_time: float = 3.0

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	var _error = tween.tween_property(spawn_indicator, "scale", Vector3(1,1,1), spawn_time-0.05)
	_error = tween.tween_property(spawn_indicator, "visible", false, 0.05)
	_error = tween.parallel().tween_property(spawn_area_indicator, "visible", false, 0.05)
	_error = tween.tween_callback(set_active)
	

func set_active():
	self.active = true
	sprite.visible = true
	despawn_timer.start(despawn_time)
	var bodies = area3D.get_overlapping_bodies()
	print(bodies)
	if bodies:
		for body in bodies:
			if body.is_in_group("boat"):
				_on_area_3d_body_entered(body)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if active and body.is_in_group("boat"):
		lightning_strike_generator.on_hit()
		#ship_selection.prompt_ui()
		print("hit")
	active = false


func _on_despawn_timer_timeout() -> void:
	self.queue_free()



