class_name Game
extends Object

static var SAVE_PATH: String = "user://game.save"

static var highscores: HighscoreList = preload("res://highscore/initial_highscores.tres").duplicate()


static func save_game() -> void:
	var save_obj: SaveGameStruct = SaveGameStruct.new()
	save_obj.highscores = highscores
	
	var file: FileAccess = FileAccess.open_compressed(
		SAVE_PATH,
		FileAccess.WRITE,
		FileAccess.COMPRESSION_ZSTD
	)
	
	if file:
		file.store_var(save_obj, true)


static func load_game() -> void:
	var file: FileAccess = FileAccess.open_compressed(
		SAVE_PATH,
		FileAccess.READ,
		FileAccess.COMPRESSION_ZSTD
	)
	
	if not file:
		return
	
	# https://forum.godotengine.org/t/how-to-load-and-save-things-with-godot-a-complete-tutorial-about-serialization/44515#but-i-heard-from-someone-that-resources-are-insecure-13
	# JSON is not save-friendly, storing and getting tons of values sequentially is error prone
	@warning_ignore("unsafe_cast") # assume and check below
	var loaded: SaveGameStruct = file.get_var(true) as SaveGameStruct
	
	if loaded:
		Game.highscores = loaded.highscores
