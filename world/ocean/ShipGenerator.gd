extends Node3D

const ROWING_BOAT_PREFAB: PackedScene = preload("res://entities/ships/rowing_boat/rowing_boat.tscn")
const TITANIC_PREFAB: PackedScene = preload("res://entities/ships/titanic/titanic.tscn")
const U_BOAT_PREFAB: PackedScene = preload("res://entities/ships/u_boat/u_boat.tscn")
const VIKING_BOAT_PREFAB: PackedScene = preload("res://entities/ships/vinking_boat/viking_boat.tscn")

@onready var camera = get_tree().get_first_node_in_group("camera")
@onready var lightning_strike_generator = get_tree().get_first_node_in_group("lightning_strike_generator")

#images
const IMG_TITANIC = preload("res://ui/hud/ship_icons/titanic.jpg")
const IMG_PIRATE = preload("res://ui/hud/ship_icons/pirate.jpg")
const img_viking = null
const img_u_boat = null

const distribution_keys = ["size", "max_speed", "turn_speed", "acceleration"]

var available_ships: Array = [
	ROWING_BOAT_PREFAB, 
	TITANIC_PREFAB, 
	U_BOAT_PREFAB, 
	VIKING_BOAT_PREFAB
	]

var ROWING_BOAT_ATTRIBUTES: Dictionary = {
	"name": "Ruderboot",
	"image": IMG_TITANIC,
	"date": "1589",
	"weight": "0.3",
	"size": [2, 1],
	"max_speed": [2, 2.0],
	"turn_speed": [9, 2.0],
	"acceleration": [5, 2.0]
}

var TITANIC_BOAT_ATTRIBUTES: Dictionary = {
	"name": "Titanic",
	"image": IMG_TITANIC,
	"date": "1912",
	"weight": "0.3",
	"size": [9, 1],
	"max_speed": [7, 1],
	"turn_speed": [1, 1],
	"acceleration": [3, 1]
}

var U_BOAT_ATTRIBUTES: Dictionary = {
	"name": "U-Boot",
	"image": IMG_TITANIC,
	"date": "1985",
	"weight": "0.3",
	"size": [7, 2],
	"max_speed": [8, 4],
	"turn_speed": [3, 1],
	"acceleration": [8, 3]
}

var VIKINGBOAT_ATTRIBUTES: Dictionary = {
	"name": "Drachenboot",
	"image": IMG_PIRATE,
	"date": "1267",
	"weight": "0.3",
	"size": [4, 2],
	"max_speed": [5, 2],
	"turn_speed": [6, 3],
	"acceleration": [5, 1]
}

@onready var ship_selection: Control = get_tree().get_first_node_in_group("ship_selection")
@onready var ocean: Node3D = get_tree().get_first_node_in_group("ocean")
var options: Array


func get_random_ship_with_attributes() -> Array:
	var rand = Globals.rng.randi_range(0, len(available_ships)-1)
	var attributes = []
	var ship_values = []
	match rand:
		0: 
			ship_values = get_randomized_ship_attributes(ROWING_BOAT_ATTRIBUTES)
			attributes = ROWING_BOAT_ATTRIBUTES
		1: 
			ship_values = get_randomized_ship_attributes(TITANIC_BOAT_ATTRIBUTES)
			attributes = TITANIC_BOAT_ATTRIBUTES
		2: 
			ship_values = get_randomized_ship_attributes(U_BOAT_ATTRIBUTES)
			attributes = U_BOAT_ATTRIBUTES
		3: 
			ship_values = get_randomized_ship_attributes(VIKINGBOAT_ATTRIBUTES)
			attributes = VIKINGBOAT_ATTRIBUTES
		
	return [available_ships[rand].instantiate(), ship_values, attributes]


func get_randomized_ship_attributes(distribution_dict: Dictionary) -> Array:
	var attributes = []
	for key in distribution_dict.keys():
		if key in distribution_keys:
			var rand = Globals.rng.randfn(distribution_dict[key][0], distribution_dict[key][1])
			rand = clamp(rand, 1.0, 10.0)
			attributes.append(rand)
		
	return attributes


func map_attributes_to_integer(array: Array) -> Array:
	var integer_array = []
	for item in array:
		integer_array.append(roundi(item))
	return integer_array


func setup_ship_options() -> void:
	options = []
	var ship_choice_display_attributes = []
	for i in range(2):
		var ship_with_attributes = get_random_ship_with_attributes()
		
		# set ship values
		var ship: Node3D = ship_with_attributes[0] # Ship
		var ship_values: Array = ship_with_attributes[1] # Distribution of modifiable attributes
		var ship_attributes: Dictionary = ship_with_attributes[2] # Dictionary of Ship Attributes
		
#		ship.set_attributes(
#			ship_values[0],
#			ship_values[1],
#			ship_values[2],
#			ship_values[3],
#		)
		options.append(ship)
		
		# setup UI
		
		var display_attributes = map_attributes_to_integer(ship_with_attributes[1])
		display_attributes.append(ship_attributes["name"])
		display_attributes.append(ship_attributes["image"])
		display_attributes.append(ship_attributes["date"])
		display_attributes.append(ship_attributes["weight"])
		display_attributes.append(i)
	
		ship_choice_display_attributes.append(display_attributes)
	ship_selection.setup_choices(ship_choice_display_attributes)


func init_new_ship(choice_index: int) -> void:
	var old_ship = get_tree().get_first_node_in_group("boat")
	options[choice_index].position = old_ship.position
	camera.player_node = options[choice_index]
	lightning_strike_generator.ship = options[choice_index]
	old_ship.queue_free()
	ocean.add_child(options[choice_index])
	#assert(len(get_tree().get_nodes_in_group("boat")) == 1) 
	
	
	

	
