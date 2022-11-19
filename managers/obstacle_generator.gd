extends Node3D

const OBSTACLE_PREFABS: Array[PackedScene] = [
	preload("res://entities/obstacles/ice.tscn"),
	preload("res://entities/obstacles/ice_berg.tscn"),
	preload("res://entities/obstacles/barrel.tscn"),
	preload("res://entities/obstacles/plank.tscn"),
	preload("res://entities/obstacles/plank_complex.tscn"),
	preload("res://entities/obstacles/shipwreck.tscn"),
	preload("res://entities/obstacles/tree.tscn"),
]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var ship: CharacterBody3D = get_tree().get_first_node_in_group("boat")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout() -> void:
	var next_obstacle = randi() % OBSTACLE_PREFABS.size()
	#var rand_position = 
	
