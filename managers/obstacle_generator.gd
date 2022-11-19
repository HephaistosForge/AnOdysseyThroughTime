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

@export var spawn_time: float = 0.4

@onready var spawn_timer: Timer = $SpawnTimer
@onready var ship: CharacterBody3D = get_tree().get_first_node_in_group("boat")
@onready var gameManager: Node3D = get_tree().get_first_node_in_group("manager")

func _ready():
	spawn_timer.start(spawn_time)

func _on_spawn_timer_timeout() -> void:
	var next_obstacle = randi() % OBSTACLE_PREFABS.size()
	var size = Globals.map_size
	var rand_position = Vector3(size.x*(randf()-0.5), 0, size.y*(randf()-0.5))
	

	if ship:
		while (rand_position-ship.position).length() > 350 or (rand_position-ship.position).length() < 30:
			rand_position = Vector3(size.x*(randf()-0.5), 0, size.y*(randf()-0.5))
	
	
	var obstacle = OBSTACLE_PREFABS[next_obstacle].instantiate()
	self.add_child(obstacle)
	obstacle.position = rand_position - Vector3(0,20,0)
	obstacle.scale = Vector3.ONE * 0.5
	
	var tween = create_tween()
	var _error = tween.tween_property(obstacle, "position", rand_position, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	#_error = tween.parallel().tween_property(obstacle, "scale", Vector3.ONE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	
	spawn_timer.start(spawn_time)
