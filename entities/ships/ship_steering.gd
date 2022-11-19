extends Node3D

class_name Ship

# Constants
@export var MAX_ACCELERATION = 1
@export var ACCELERATION_MULTIPLIER = 0.04
@export var MAX_SPEED = 10

@export var MAX_TURN_ACCELERATION = 0.01
@export var MIN_TURN_ACCELERATION = 0.001  # A sailing boat should have 0, since it cannot turn without speed
@export var MAX_TURN_SPEED = 0.05
@export var TURN_ACCELERATION_FACTOR = 0.5

@export var FRICTION = 0.01
@export var SIDEWAYS_FRICTION_MULTIPLIER = 3

@export var right_move_anim = "move_right"
@export var left_move_anim = "move_left"

@export var accelerate_only_on_accelerate_signal = true

var anchor

func interpolate0to10(value, _min, _max):
	var diff = _max - _min;
	return diff * (value / 10.0) + _min;

func set_attributes(_size, _max_speed, _turn_speed, _acceleration):
	scale = interpolate0to10(_size, 0.5, 3) * Vector3(1,1,1)
	
	MAX_SPEED = interpolate0to10(_max_speed, 5, 30)
	
	MAX_TURN_SPEED = interpolate0to10(_turn_speed, 0.03, 0.15)
	
	MAX_TURN_ACCELERATION = interpolate0to10(_acceleration, 0.005, 0.05)
	TURN_ACCELERATION_FACTOR = interpolate0to10(_acceleration, 0.2, 1.5)
	MAX_ACCELERATION = interpolate0to10(_acceleration, 0.5, 10)
	ACCELERATION_MULTIPLIER = interpolate0to10(_acceleration, 0.01, 0.1)
	


# In radians
var turn_speed = 0
var turn_acceleration = 0

# velocity and position is already defined in godot object
var acceleration = Vector3.ZERO

var forward_vec = Vector3(0, 0, -1)
var forward_vec_global = Vector3.ZERO

var move_left_right_separately = false
var axis = Vector3(0, 1, 0)

		
func accelerate_on_signal(vector):
	acceleration += vector

func _ready():
	anchor = get_tree().get_first_node_in_group("anchor")
	if accelerate_only_on_accelerate_signal:
		parent.get_node("Model").connect("accelerate", accelerate_on_signal)

func point_anchor():
	var ship = get_tree().get_first_node_in_group("boat")
	var ship_to_mid = -ship.position
	var theta = atan2(ship_to_mid.x, ship_to_mid.z)
	
	anchor.rotate(Vector3(0,1,0), theta - anchor.global_rotation.y)

func action_strength(_name):
	return Input.get_action_strength(_name)
	
func normalize_vec_with_max(vec, max_val):
	if vec.length() > max_val:
		vec = vec.normalized() * max_val
	return vec

@onready var parent = get_parent()
@onready var anim_player = get_parent().get_node("Model").get_node("AnimationPlayer")

func _physics_process(_delta: float) -> void:
	point_anchor()
	
	acceleration *= 0.9
	turn_acceleration *= 0.9
	
	forward_vec_global = Vector3(cos(parent.rotation.y), 0, sin(parent.rotation.y))
	$RayForwardVec.target_position = forward_vec_global.normalized()
	var velocity_vec_global = parent.velocity.rotated(axis, -parent.rotation.y)
	$RayVelocity.target_position = velocity_vec_global.normalized()
	
	$RayAcceleration.target_position = (acceleration * 10).normalized()
	var forward_component = abs(velocity_vec_global.normalized().dot(forward_vec))
	var drift_component = 1 - forward_component
	var sideways_friction = FRICTION * SIDEWAYS_FRICTION_MULTIPLIER
	var friction = FRICTION * forward_component + sideways_friction * drift_component
	
	
	var strength = action_strength("move_forwards") - action_strength("move_backwards") * 0.02
	acceleration += (forward_vec * strength * ACCELERATION_MULTIPLIER)
	acceleration = normalize_vec_with_max(acceleration, MAX_ACCELERATION)
		
		
	var raw_turning = action_strength("turn_left") - action_strength("turn_right")
	turn_acceleration = raw_turning / 5000.0 * sqrt(abs(parent.velocity.z)) * TURN_ACCELERATION_FACTOR
	turn_acceleration = clamp(turn_acceleration, -MAX_TURN_ACCELERATION, MAX_TURN_ACCELERATION)
	turn_speed += turn_acceleration
	turn_speed = clamp(turn_speed, -MAX_TURN_SPEED, MAX_TURN_SPEED)
	
	acceleration = acceleration.rotated(axis, -turn_speed)
	
	if parent.has_node("AnimationTree"):
		var anim_tree = parent.get_node("AnimationTree")
		
		anim_tree.set("parameters/TimeScale/scale", max(acceleration.length()*2, strength * 3))
		if move_left_right_separately:
			var left_ratio = clamp(acceleration.x, -0.5, 0.5) * 2 + 1
			var right_ratio = 2 - left_ratio
			anim_tree.set("parameters/LeftScale/scale", left_ratio)
			anim_tree.set("parameters/RightScale/scale", right_ratio)

	#anim_player.playback_speed = acceleration.length() * 100
	#if acceleration:
	#	if not anim_player.is_playing():
	#		anim_player.play("LeftPaddling")
	#		anim_player.play("RightPaddling")
	
	turn_speed *= 1 - friction
	parent.rotate(axis, turn_speed)
	
	parent.velocity *= 1 - friction
	parent.velocity += acceleration.rotated(axis, parent.rotation.y)
	parent.velocity = normalize_vec_with_max(parent.velocity, MAX_SPEED)
	
	parent.move_and_slide()
