extends Node3D

@export var map_size = Vector2(2500,2500)

const WIN_SCENE: PackedScene = preload("res://ui/game_end/win.tscn")
const LOSE_SCENE: PackedScene = preload("res://ui/game_end/loose.tscn")

var changed = false
@onready var score_tracker = get_tree().get_first_node_in_group("score_tracker")
const WIN_SCORE = 10000


func lose():
	Globals.start_pos = Vector3.ZERO
	assert(get_tree().change_scene_to_packed(LOSE_SCENE) == 0)

func win():
	Globals.start_pos = Vector3.ZERO
	assert(get_tree().change_scene_to_packed(WIN_SCENE) == 0)

func _ready():
	if Globals.start_pos != Vector3.ZERO:
		var ship = get_tree().get_first_node_in_group("boat")
		var cam = get_tree().get_first_node_in_group("camera")
		
		var old_pos = ship.position
		var new_pos = Vector3(Globals.start_pos.x, old_pos.y, Globals.start_pos.z)
		var diff = new_pos - old_pos
		cam.position = cam.position + diff
		ship.position = new_pos
		
		changed = true
		
		var mid_to_ship = ship.position
		var cam_to_ship = ship.position - cam.position
		
		var theta_mid = atan2(mid_to_ship.z, mid_to_ship.x)
		var theta_cam = atan2(cam_to_ship.z, cam_to_ship.x)
		
		var rotate_angle = theta_mid - theta_cam + PI
		
		cam.rotate_around_ship(rotate_angle)
		ship.rotate(Vector3(0,1,0), -rotate_angle)
		
		
func start_game(pos):
	Globals.start_pos = pos*1.6
	assert(get_tree().change_scene_to_file("res://world/ocean/ocean.tscn") == 0)


func _on_goal_area_body_entered(body):
	if Globals.start_pos != Vector3.ZERO:
		if body.is_in_group("boat"):
			if changed:
				score_tracker.add_score(WIN_SCORE)
				win()
