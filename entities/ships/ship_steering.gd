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

# In radians
var turn_speed = 0
var turn_acceleration = 0

# velocity and position is already defined in godot object
var acceleration = Vector3.ZERO

var forward_vec = Vector3(0, 0, -1)
var forward_vec_gloal = Vector3.ZERO


var axis = Vector3(0, 1, 0)

func action_strength(_name):
	return Input.get_action_strength(_name)
	
func normalize_vec_with_max(vec, max_val):
	if vec.length() > max_val:
		vec = vec.normalized() * max_val
	return vec

@onready var parent = get_parent()

func _physics_process(_delta: float) -> void:
	
	acceleration *= 0.9
	turn_acceleration *= 0.9
	
	forward_vec_gloal = Vector3(cos(parent.rotation.y), 0, sin(parent.rotation.y))
	$RayForwardVec.target_position = forward_vec_gloal
	var velocity_vec_global = parent.velocity.rotated(axis, -parent.rotation.y)
	$RayVelocity.target_position = velocity_vec_global
	
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
	
	turn_speed *= 1 - friction
	parent.rotate(axis, turn_speed)
	
	parent.velocity *= 1 - friction
	parent.velocity += acceleration.rotated(axis, parent.rotation.y)
	parent.velocity = normalize_vec_with_max(parent.velocity, MAX_SPEED)
	
	parent.move_and_slide()
