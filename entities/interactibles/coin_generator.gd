extends Node3D

const coin_prefab = preload("res://entities/interactibles/coin.tscn")

@export var spawn_time: float = 5.0

@onready var spawn_timer: Timer = $SpawnTimer
@onready var ship: CharacterBody3D = get_tree().get_first_node_in_group("boat")


func _ready():
	spawn_timer.start(spawn_time)

func _on_spawn_timer_timeout() -> void:
	var size = Globals.map_size
	var rand_position = Vector3(size.x*(randf()-0.5), 0, size.y*(randf()-0.5))
	
	if ship and is_instance_valid(ship):
		while (rand_position-ship.position).length() > 350 or (rand_position-ship.position).length() < 30:
			rand_position = Vector3(size.x*(randf()-0.5), 0, size.y*(randf()-0.5))
	
	
	var coin = coin_prefab.instantiate()
	self.add_child(coin)
	coin.position = rand_position - Vector3(0,20,0)
	coin.scale = Vector3.ONE * 0.5
	
	var tween = create_tween()
	var _error = tween.tween_property(coin, "position", rand_position, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	#_error = tween.parallel().tween_property(obstacle, "scale", Vector3.ONE, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	
	spawn_timer.start(spawn_time)
