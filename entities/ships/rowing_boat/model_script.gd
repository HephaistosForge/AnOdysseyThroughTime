extends Node3D


signal accelerate

func emit_accelerate_left():
	emit_accelerate(Vector3(-0.2, 0, -1))
	
func emit_accelerate_right():
	emit_accelerate(Vector3(0.2, 0, -1))

func emit_accelerate(vector):
	emit_signal("accelerate", vector)
