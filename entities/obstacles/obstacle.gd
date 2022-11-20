extends RigidBody3D

var model : Node3D

var rmoved = false

func _ready():
	for c in get_children():
		if c is Node3D and not c is CollisionShape3D:
			model = c
	assert(model != null)

func rm(pos):
	if rmoved:
		return
	else:
		rmoved = true
	
	var tween = create_tween()
	var _error = tween.tween_property(model, "scale", Vector3.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_error = tween.tween_callback(queue_free)

