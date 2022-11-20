extends Area3D

func _on_body_entered(body):
	print_debug("obstacle_entered")
	if body.is_in_group("obstacle"):
		#body.rm(global_position)
		body.rm()
	elif body.is_in_group("boat"):
		get_tree().get_first_node_in_group("manager").lose()
