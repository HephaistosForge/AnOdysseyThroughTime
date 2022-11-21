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
var maelstrom = null

var obstacle_mass = 10

const OBSTACLE_LIMIT = 100
const OBSTACLE_REMOVAL_RANGE = 500


@export var spawn_time: float = 0.27

@onready var spawn_timer: Timer = $SpawnTimer
@onready var ship: CharacterBody3D = get_tree().get_first_node_in_group("boat")
@onready var gameManager: Node3D = get_tree().get_first_node_in_group("manager")

func _ready():
	spawn_timer.start(spawn_time)
	if get_tree().get_first_node_in_group("maelstroms"):
		maelstrom = get_tree().get_first_node_in_group("maelstroms")
	
	for i in 25:
		spawn()
	
func spawn():	
	# remove furthest away obstacles if threshhold is reached
	if len(get_tree().get_nodes_in_group("pullable")) > OBSTACLE_LIMIT:
		var obstacles = get_tree().get_nodes_in_group("pullable")
		obstacles.sort_custom(sort_by_distance_to_ship)
		var obstacles_to_remove = obstacles.slice(OBSTACLE_LIMIT, len(obstacles))
		for obstacle in obstacles_to_remove:
			obstacle.queue_free()
	# if threshhold not hit: remove all items that are out of range
	else:
		for obstacle in get_tree().get_nodes_in_group("pullable"):
			if is_instance_valid(ship):
				if obstacle.global_position.distance_to(ship.global_position) > OBSTACLE_REMOVAL_RANGE:
					obstacle.queue_free()
		
	var next_obstacle = randi() % OBSTACLE_PREFABS.size()
	var size = Globals.map_size
	var rand_position = Vector3(size.x*(randf()-0.5), 0, size.y*(randf()-0.5))
	
	if ship and is_instance_valid(ship):
		while (rand_position-ship.position).length() > 350 or (rand_position-ship.position).length() < 30:
			rand_position = Vector3(size.x*(randf()-0.5), 0, size.y*(randf()-0.5))
	
	var obstacle = OBSTACLE_PREFABS[next_obstacle].instantiate()
	self.add_child(obstacle)
	if maelstrom:
		var h = maelstrom.get_depth_at_world_xz(rand_position.x, rand_position.z)
		if h != null:
			rand_position.y = h
	obstacle.position = rand_position - Vector3(0,20,0)
	#obstacle.scale *= 10
	#obstacle.mass = obstacle_mass
	
	var tween = create_tween()
	var _error = tween.tween_property(obstacle, "position", rand_position, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	#_error = tween.parallel().tween_property(obstacle, "scale", Vector3.ONE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func sort_by_distance_to_ship(a,b):
	ship = get_tree().get_first_node_in_group("boat")
	return ship.global_position.distance_to(a.global_position) < ship.global_position.distance_to(b.global_position)



func _on_spawn_timer_timeout() -> void:
	spawn()
	
	spawn_timer.start(spawn_time)
	
