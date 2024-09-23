class_name HighscoreMenu
extends Node2D

@onready var ui_highscore_list: UIHighscoreList = $CanvasLayer/CenterContainer/UIHighscoreList

func _ready() -> void:
	ui_highscore_list.list = Game.highscores


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
