extends Control


func _on_cancel_button_pressed():
	self.visible = false
	get_tree().paused = false
