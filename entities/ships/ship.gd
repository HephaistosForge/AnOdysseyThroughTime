extends CharacterBody3D

# Constants
const MAX_ACCELERATION = 1
const ACCELERATION_MULTIPLIER = 0.04
const MAX_SPEED = 10
const MAX_TURN_ACCELERATION = 0.01
const MIN_TURN_ACCELERATION = 0.001  # A sailing boat should have 0, since it cannot turn without speed
const MAX_TURN_SPEED = 0.05

const FRICTION = 0.01
const SIDEWAYS_FRICTION_MULTIPLIER = 3

# In radians
#var direction = 0
var turn_speed = 0
var turn_acceleration = 0

# velocity and position is already defined in godot object
var acceleration = Vector3.ZERO

# var const_acceleration = Vector3(0, 0, 0.01)

var forward_vec = Vector3(0, 0, -1)
var forward_vec_gloal = Vector3.ZERO


var axis = Vector3(0, 1, 0)

func action_strength(name):
	return Input.get_action_strength(name)
	
func normalize_vec_with_max(vec, max_val):
	if vec.length() > max_val:
		vec = vec.normalized() * max_val
	return vec


#func _draw():
#	get_parent().draw_line(Vector2.ZERO, Vector2(cos(direction), sin(direction)))


func _physics_process(delta: float) -> void:
	var movement = 4 * forward_vec
	
	acceleration *= 0.9
	turn_acceleration *= 0.9
	
	forward_vec_gloal = Vector3(cos(rotation.y), 0, sin(rotation.y))
	$forward_vec.target_position = forward_vec_gloal
	var velocity_vec_global = velocity.rotated(axis, -rotation.y)
	$velocity.target_position = velocity_vec_global
	
	$acceleration.target_position = acceleration * 10
	var forward_component = abs(velocity_vec_global.normalized().dot(forward_vec))
	var drift_component = 1 - forward_component
	var sideways_friction = FRICTION * SIDEWAYS_FRICTION_MULTIPLIER
	var friction = FRICTION * forward_component + sideways_friction * drift_component
	velocity *= 1 - friction
	turn_speed *= 1 - friction
	

	
	var strength = action_strength("move_forwards") - action_strength("move_backwards") * 0.02
	acceleration += (forward_vec * strength * ACCELERATION_MULTIPLIER) #.rotated(axis, direction)
	# acceleration.z = clamp(acceleration.z, -MAX_ACCELERATION, MAX_ACCELERATION)
	acceleration = normalize_vec_with_max(acceleration, MAX_ACCELERATION)
	#movement.z -= strength * 20
		
		
	var raw_turning = action_strength("turn_left") - action_strength("turn_right")
	turn_acceleration = raw_turning / 3000.0 * sqrt(abs(velocity.z))
	turn_acceleration = clamp(turn_acceleration, -MAX_TURN_ACCELERATION, MAX_TURN_ACCELERATION)
	turn_speed += turn_acceleration
	turn_speed = clamp(turn_speed, -MAX_TURN_SPEED, MAX_TURN_SPEED)
	
	acceleration = acceleration.rotated(axis, -turn_speed)
	#direction -= turn_speed / 8
	rotate(axis, turn_speed)
	#	movement.x += Input.get_action_strength("move_forwards")
	#if Input.is_action_pressed("move_backwards"):
	#	movement.x -= Input.get_action_strength("move_backwards")
	#var direction = -rotation.angle_to(forward_vec)
	velocity += acceleration.rotated(axis, rotation.y)
	velocity = normalize_vec_with_max(velocity, MAX_SPEED)
	
	if movement:
		#if movement.length() > 1:
		#	movement = movement.normalized()
		move_and_slide()
