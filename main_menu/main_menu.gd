class_name MainMenu
extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var line_edit_player_name: LineEdit = $CanvasLayer/VBoxContainer2/LineEditPlayerName


func _ready() -> void:
	Game.load_game()
	Game.settings.apply()
	line_edit_player_name.text = Game.player_name


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level/level.tscn")
	Game.save_game()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
	Game.save_game()


func _on_button_options_pressed() -> void:
	canvas_layer.add_child(OptionsMenu.create())


func _on_button_highscores_pressed() -> void:
	get_tree().change_scene_to_file("res://highscore/highscore_menu.tscn")


func _on_line_edit_player_name_text_changed(new_text: String) -> void:
	Game.player_name = new_text
