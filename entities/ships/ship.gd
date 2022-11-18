extends CharacterBody3D

# Constants
var max_acceleration = 1
var max_speed = 10
const MAX_TURN_ACCELERATION = .01
const MAX_TURN_SPEED = .1
# const MIN_TURNING = 0.1

var turn_speed = 0
var turn_acceleration = 0
var acceleration = Vector3.ZERO

var const_acceleration = Vector3(0, 0, 0.01)

var forward_vec = Vector3(0, 0, -1)
var direction = 0

var axis = Vector3(0, 1, 0)

func action_strength(name):
	return Input.get_action_strength(name)

func _physics_process(delta: float) -> void:
	var movement = Vector3(0, 0, -4)
	
	acceleration *= 0.9
	velocity *= 0.99
	turn_acceleration *= 0.9
	turn_speed *= 0.94
	
	
	
	var strength = action_strength("move_forwards") - action_strength("move_backwards") * 0.02
	acceleration.z -= strength / 10
	acceleration.z = clamp(acceleration.z, -max_acceleration, max_acceleration)
	#movement.z -= strength * 20
		
		
	var raw_turning = action_strength("turn_left") - action_strength("turn_right")
	turn_acceleration = raw_turning / 500.0 * sqrt(abs(velocity.z))
	turn_acceleration = clamp(turn_acceleration, -MAX_TURN_ACCELERATION, MAX_TURN_ACCELERATION)
	turn_speed += turn_acceleration
	turn_speed = clamp(turn_speed, -MAX_TURN_SPEED, MAX_TURN_SPEED)
	direction += turn_speed
	rotate(axis, turn_speed)
	#	movement.x += Input.get_action_strength("move_forwards")
	#if Input.is_action_pressed("move_backwards"):
	#	movement.x -= Input.get_action_strength("move_backwards")
	#var direction = -rotation.angle_to(forward_vec)
	velocity += acceleration.rotated(axis, direction)
	#velocity += const_acceleration.rotated(axis, direction)
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	if movement:
		#if movement.length() > 1:
		#	movement = movement.normalized()
		move_and_slide()
