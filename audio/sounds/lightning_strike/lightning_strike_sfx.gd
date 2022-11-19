extends AudioStreamPlayer3D


func _ready():
	assert(self.finished.connect(_on_stream_finished) == 0)


func _on_stream_finished() -> void:
	queue_free()
