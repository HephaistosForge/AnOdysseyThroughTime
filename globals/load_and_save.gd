extends Node

const path: String = "user://save_file.json"
const password: String = "c37c82x9x20,c...v9evu38"


var game_data: Dictionary = {}


func _ready():
	_load_save_file()
	_init_highscore()


func _init_highscore():
	if "highscore" not in game_data.keys():
		game_data ={"highscore": [
			000000,
			000000,
			000000
		]}
		

func _save_game() -> void:
	FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, password).store_string(JSON.stringify(game_data))


func _load_save_file() -> void:
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, password)
	if file:
		game_data = JSON.parse_string(file.get_as_text())
	
	
