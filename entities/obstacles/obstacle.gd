extends RigidBody3D

var model : Node3D

func _ready():
	for c in get_children():
		if c is Node3D and not c is CollisionShape3D:
			model = c
	assert(model != null)

func rm(pos):
	if freeze:
		return
	else:
		freeze = true
	
	pos -= position
	var tween = create_tween()
	var _error = tween.tween_property(model, "position", pos, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_error = tween.tween_property(model, "position", pos - Vector3(0,30,0), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	_error = tween.tween_property(model, "scale", Vector3.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_error = tween.tween_callback(queue_free)

