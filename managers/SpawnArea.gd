extends Area3D


@onready var gameManager = get_tree().get_first_node_in_group("manager")

func _on_mouse_entered():
	print("Entered")


func _on_mouse_exited():
	print("Exited")


func _on_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			var pos = click_position
			gameManager.start_game(click_position)
