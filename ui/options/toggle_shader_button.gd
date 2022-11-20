extends CheckButton


func _process(_delta):
	self.set_pressed_no_signal(Globals.enable_good_graphics)


func _on_toggled(_pressed):
	Globals.enable_good_graphics = !Globals.enable_good_graphics
	print(Globals.enable_good_graphics)
