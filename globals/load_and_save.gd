extends Node

const path: String = "user://save_file.json"
const password: String = "c37c82x9x20,c...v9evu38"


var game_data: Dictionary = {}


func _ready():
	_load_save_file()
	_init_highscore()


func _init_highscore():
	if "highscore" not in game_data.keys():
		var highscores = []
		for i in range(10):
			highscores.append(0)
		game_data["highscore"] = highscores


func check_for_new_highscore(_new_score) -> bool:
	var highscores = game_data["highscore"]
	var insert_at_index: int
	for i in range(len(highscores)):
		if _new_score > highscores[i]:
			insert_at_index = i
			break
	if insert_at_index != null:
		game_data["highscore"].insert(insert_at_index, _new_score)
		game_data["highscore"].pop_back()
		_save_game()
		return true
	return false
		


func _save_game() -> void:
	FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, password).store_string(JSON.stringify(game_data))


func _load_save_file() -> void:
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, password)
	if file:
		game_data = JSON.parse_string(file.get_as_text())
	
	
