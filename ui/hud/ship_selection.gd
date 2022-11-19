extends Control

#images
const img_titanic = preload("res://ui/hud/ship_icons/titanic.jpg")
const img_pirate = preload("res://ui/hud/ship_icons/pirate.jpg")

@onready var option_1: PanelContainer = $Panel/VBoxContainer/Auswahl/MarginContainer/Option_1
@onready var option_2: PanelContainer = $Panel/VBoxContainer/Auswahl/MarginContainer2/Option_2

func setup_choices():
	option_1.init_values('Titanic', img_titanic, 10, 30, 90, '1909', '20', '5', '10')
	option_2.init_values('Pirate', img_pirate, 10, 30, 90, '1806', '20', '5', '10')

func _ready():
	setup_choices()
