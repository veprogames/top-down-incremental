class_name MainMenu
extends Node2D


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level/level.tscn")


func _on_button_quit_pressed() -> void:
	get_tree().quit()
