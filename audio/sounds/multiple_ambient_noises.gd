extends AudioStreamPlayer3D

@export var streams: Array[AudioStream]
@onready var timer: Timer = Timer.new()


func _ready():
	add_child(timer)
	
	assert(timer.timeout.connect(_on_timer_timeout) == 0)
	assert(self.finished.connect(_on_stream_finished) == 0)
	
	_play_random_stream()


func _play_random_stream() -> void:
	stream = streams[randi() % len(streams) - 1]
	self.play()


func _on_timer_timeout() -> void:
	_play_random_stream()


func _on_stream_finished() -> void:
	timer.start(randi() % 20 + 10)
