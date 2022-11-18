extends Camera3D


@export var player: NodePath
@export var pan_speed = 2

var player_node: Node3D
var offset_to_player

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	player_node = get_node(player)
	
	offset_to_player = global_position - player_node.global_position

func _process(delta):
	
	
	var theta = atan2(offset_to_player.z, offset_to_player.x)
	var r = sqrt(offset_to_player.z*offset_to_player.z + offset_to_player.x*offset_to_player.x)
	
	var pan = Input.get_action_strength("pan_right") - Input.get_action_strength("pan_left")
	pan = pan_speed*pan/100
	theta += pan
	
	var x = r * cos(theta)
	var z = r * sin(theta)
	offset_to_player = Vector3(x,offset_to_player.y,z)
	
	rotate(Vector3(0,1,0), -pan)
	
	global_position = player_node.global_position + offset_to_player
