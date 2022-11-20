extends PanelContainer
@onready var name_label: Label = $CenterContainer/VBoxContainer/Name/Name

@onready var ship_size: TextureProgressBar = $"CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Größe"

@onready var geschwindigkeit = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Geschwindigkeit
@onready var wendigkeit = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Wendigkeit
@onready var beschleunigung = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Beschleunigung

@onready var jahrgang_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Jahrgang_Wert

@onready var gewicht_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Gewicht_Wert

@onready var ship_image: TextureRect = $CenterContainer/VBoxContainer/MarginContainer/Image2


var option_index

func init_values(attributes):
	
	name_label.text = attributes[4]
	
	ship_image.texture = attributes[5]
	
	geschwindigkeit.value = attributes[1] * 10
	wendigkeit.value = attributes[2] * 10
	beschleunigung.value = attributes[3] * 10
	ship_size.value = attributes[0] * 10
	
	jahrgang_label.text = attributes[6]
	gewicht_label.text = attributes[7]
	option_index = attributes[8]


func _on_button_pressed() -> void:
	print("hello")
	get_tree().paused = false
	get_tree().get_first_node_in_group("ship_selection").do_hide()
	get_tree().get_first_node_in_group("ship_generator").init_new_ship(option_index)
