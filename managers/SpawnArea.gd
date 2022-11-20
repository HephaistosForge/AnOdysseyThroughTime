extends Area3D


@onready var gameManager = get_tree().get_first_node_in_group("manager")

func _on_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	# Todo: Werden _camera, _click_normal und _shape_idx in dieser Methode benötigt??
	if event is InputEventMouseButton and event.button_index == 1:
		gameManager.start_game(click_position)
