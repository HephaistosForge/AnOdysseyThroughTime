extends PanelContainer
@onready var name_label: Label = $CenterContainer/VBoxContainer/Name/Name

#@onready var image = $CenterContainer/VBoxContainer/Image2

@onready var geschwindigkeit = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Geschwindigkeit
@onready var wendigkeit = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Wendigkeit
@onready var beschleunigung = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Beschleunigung

@onready var jahrgang_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Jahrgang_Wert
@onready var laenge_label: Label = $"CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Länge_Wert"
@onready var breite_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Breite_Wert
@onready var gewicht_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Gewicht_Wert

@onready var ship_image: TextureRect = $CenterContainer/VBoxContainer/Image2

func init_values(_name, _ship_image, _geschwindigkeit, _wendigkeit, _beschleunigung, _jahrgang, _laenge, _breite, _gewicht):
	name_label.text = _name
	
	ship_image.texture = _ship_image
	
	geschwindigkeit.value = _geschwindigkeit
	wendigkeit.value = _wendigkeit
	beschleunigung.value = _beschleunigung
	
	jahrgang_label.text = _jahrgang
	laenge_label.text = _laenge
	breite_label.text = _breite
	gewicht_label.text = _gewicht
