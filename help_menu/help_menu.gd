class_name HelpMenu
extends Node2D

var MainMenuScene: PackedScene = load("res://main_menu/main_menu.tscn")


func _on_button_back_pressed() -> void:
	SceneSwitcher.change(MainMenuScene)
