extends Control

@onready var option_1: PanelContainer = $CanvasLayer/Panel/VBoxContainer/Auswahl/MarginContainer/Option_1
@onready var option_2: PanelContainer = $CanvasLayer/Panel/VBoxContainer/Auswahl/MarginContainer2/Option_2


func _ready():
	self.visible = false
	$CanvasLayer.visible = false


func prompt_ui():
	get_tree().paused = true
	get_parent().setup_ship_options()
	self.visible = true
	$CanvasLayer.visible = true


func setup_choices(choices):
	option_1.init_values(choices[0])
	option_2.init_values(choices[1])

