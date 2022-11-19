extends AudioStreamPlayer3D

@onready var timer: Timer = Timer.new()


func _ready():
	add_child(timer)
	
	assert(timer.timeout.connect(_on_timer_timeout) == 0)
	assert(self.finished.connect(_on_stream_finished) == 0)
	
	self.play()


func _on_timer_timeout() -> void:
	self.play()


func _on_stream_finished() -> void:
	timer.start(randi() % 10 + 20)
