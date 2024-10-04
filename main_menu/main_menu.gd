class_name MainMenu
extends Node2D

var LevelScene: PackedScene = preload("res://level/level.tscn")
var HighscoreScene: PackedScene = preload("res://highscore/highscore_menu.tscn")

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var line_edit_player_name: LineEdit = $CanvasLayer/VBoxContainer2/LineEditPlayerName


func _ready() -> void:
	randomize()
	Game.load_game()
	Game.settings.apply()
	line_edit_player_name.text = Game.player_name


func _on_button_play_pressed() -> void:
	SceneSwitcher.change(LevelScene)
	Game.save_game()


func _on_button_quit_pressed() -> void:
	SceneSwitcher.quit()
	Game.save_game()


func _on_button_options_pressed() -> void:
	canvas_layer.add_child(OptionsMenu.create())


func _on_button_highscores_pressed() -> void:
	SceneSwitcher.change(HighscoreScene)


func _on_line_edit_player_name_text_changed(new_text: String) -> void:
	Game.player_name = new_text
