extends Node3D

const LIGHTNING_STRIKE_PREFAB: PackedScene = preload("res://world/weather/lightning_strike.tscn")

enum DIFFICULTY {
	PEACEFUL,
	EASY,
	MEDIUM,
	HARD,
	DEADLY
}

const DIFFICULTY_ATTRIBUTES: Dictionary = {
	DIFFICULTY.PEACEFUL: [30, 10],
	DIFFICULTY.EASY: [20, 8],
	DIFFICULTY.MEDIUM: [15, 6],
	DIFFICULTY.HARD: [10, 4],
	DIFFICULTY.DEADLY: [5, 2]
}

@onready var spawn_timer: Timer = $SpawnTimer
@onready var ship: CharacterBody3D = get_tree().get_first_node_in_group("boat")
var time_since_last_hit
var last_hit
var difficulty = DIFFICULTY.PEACEFUL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_hit = Time.get_unix_time_from_system()


func set_difficulty() -> void:
	if time_since_last_hit > 120:
		difficulty = DIFFICULTY.DEADLY
	elif time_since_last_hit > 90:
		difficulty = DIFFICULTY.HARD
	elif time_since_last_hit > 60:
		difficulty = DIFFICULTY.MEDIUM
	elif time_since_last_hit > 30:
		difficulty = DIFFICULTY.EASY
	else:
		difficulty = DIFFICULTY.PEACEFUL


func get_randomized_spawn_position() -> Vector3:
	var spawn_range = DIFFICULTY_ATTRIBUTES[difficulty][0]

	return ship.position + Vector3(
		Globals.rng.randf_range(-spawn_range, spawn_range),
		0,
		Globals.rng.randf_range(-spawn_range, spawn_range)
	)


func on_hit():
	last_hit = Time.get_unix_time_from_system()


func _on_timer_timeout() -> void:
	var now = Time.get_unix_time_from_system()
	time_since_last_hit = now - last_hit
	set_difficulty()
	var lightning_strike = LIGHTNING_STRIKE_PREFAB.instantiate()
	self.add_child(lightning_strike)
	lightning_strike.position = get_randomized_spawn_position()
	spawn_timer.start(DIFFICULTY_ATTRIBUTES[difficulty][1])
	
	
