extends Control

@export var inital_dialog: Array[String] = ["<Fehlender Text>"]
@export var follow_up_dialog: Array[String] = ["<Fehlender Text>"]
@export var name_of_speaker: Array[String] = ["<Fehlender Text>"]

@export var text_speed = 0.05

@export var label_name_path: NodePath
@export var label_text_path: NodePath

@onready var timer: Timer = Timer.new()

var label_name: Label
var label_text: Label

var chosen_dialog: Array[String] = []
var chosen_name_of_speaker: String = ""

var waiting_for_phrase_switch: bool = false
var finished: bool = false
var array_counter: int = 0
var char_counter: int = 0


func _ready():
	chosen_dialog = [
		inital_dialog[randi() % len(inital_dialog)],
		follow_up_dialog[randi() % len(inital_dialog)]
		]
	
	chosen_name_of_speaker = name_of_speaker[randi() % len(name_of_speaker)]
	
	add_child(timer)
	timer.autostart = true
	timer.wait_time = text_speed
	assert(timer.timeout.connect(_on_timer_timeout) == 0)
	
	label_name = get_node(label_name_path)
	label_text = get_node(label_text_path)
	
	_next_phrase()


func _process(_delta):
	if Input.is_action_pressed("ui_accept") and not finished and not waiting_for_phrase_switch:
		_next_phrase()


func _on_timer_timeout() -> void:
	if not finished:
		if waiting_for_phrase_switch:
			waiting_for_phrase_switch = false
		
		_next_phrase()
	else:
		queue_free()


func _timer_restart(cooldown: float = 1.0):
	timer.stop()
	timer.start(cooldown)


func _next_phrase() -> void:
	if char_counter >= len(chosen_dialog[array_counter]):
		# Show, if possible, next dialog line
		if array_counter + 1 < len(chosen_dialog):
			array_counter += 1
			char_counter = 0
			waiting_for_phrase_switch = true
			_timer_restart()
			return
		else:
			finished = true
			_timer_restart()
			return
	
	label_name.text = chosen_name_of_speaker
	label_text.text = chosen_dialog[array_counter]
	
	char_counter += 1
	
	label_text.visible_characters = char_counter
	
	timer.start(text_speed)
