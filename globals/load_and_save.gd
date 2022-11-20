extends Node

const path: String = "user://save_file.json"
const password: String = "c37c82x9x20,c...v9evu38"


var game_data: Dictionary = {
	0: {"highscore": 0}
}

func _save_game() -> void:
	FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, password).store_string(JSON.stringify(game_data))


func _load_save_file() -> void:
	game_data = JSON.parse_string(FileAccess.open_encrypted_with_pass(path, FileAccess.READ, password).get_as_text())
