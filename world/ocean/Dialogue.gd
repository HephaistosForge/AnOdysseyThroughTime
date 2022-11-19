# adapted from https://www.youtube.com/watch?v=GzPvN5wsp7Y

extends ColorRect
 
@export var textSpeed = 0.05
 
var dialog = [["Name1","ASldfkas sdfkl jsölfj eslkfjseölkf jösdlf as as "], ["Name2", "sad ads asd asd asdsadad"]]
 
var phraseNum = 0
var finished = false
 
func _ready():
	$Timer.wait_time = textSpeed
	nextPhrase()
 
func _process(_delta):
	#$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
 
 
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
		return
	
	finished = false
	
	$VBoxContainer/Name.text = dialog[phraseNum][0]
	$VBoxContainer/Text.text = dialog[phraseNum][1]
	
	$VBoxContainer/Text.visible_characters = 0
	while $VBoxContainer/Text.visible_characters < len($VBoxContainer/Text.text):
		$VBoxContainer/Text.visible_characters += 1
		
		$Timer.start()
		await $Timer.timeout
	
	finished = true
	phraseNum += 1
	return
