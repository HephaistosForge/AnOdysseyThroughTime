extends PanelContainer
@onready var name_label: Label = $CenterContainer/VBoxContainer/Name/Name

@onready var geschwindigkeit = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Geschwindigkeit
@onready var wendigkeit = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Wendigkeit
@onready var beschleunigung = $CenterContainer/VBoxContainer/Attribute/MarginContainer/GridContainer/Texture_Beschleunigung

@onready var jahrgang_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Jahrgang_Wert
@onready var laenge_label: Label = $"CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Länge_Wert"
@onready var breite_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Breite_Wert
@onready var gewicht_label: Label = $CenterContainer/VBoxContainer/Trivia/MarginContainer/GridContainer/Gewicht_Wert

# Called when the node enters the scene tree for the first time.
func _ready():
	init_values('Titanic', 10, 30, 90, '1909', '20', '5', '10')
	
	
func init_values(_name, _geschwindigkeit, _wendigkeit, _beschleunigung, _jahrgang, _laenge, _breite, _gewicht):
	name_label.text = _name
	
	geschwindigkeit.value = _geschwindigkeit
	wendigkeit.value = _wendigkeit
	beschleunigung.value = _beschleunigung
	
	jahrgang_label.text = _jahrgang
	laenge_label.text = _laenge
	breite_label.text = _breite
	gewicht_label.text = _gewicht
