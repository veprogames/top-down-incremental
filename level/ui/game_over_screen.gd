class_name GameOverScreen
extends Control

signal restarted
signal faded_out


@onready var ui_highscore_list: UIHighscoreList = $Control/UIHighscoreList


func initialize() -> void:
	modulate.a = 0
	ui_highscore_list.list = Game.highscores


func fade_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"modulate:a", 1, 1) \
		.set_ease(Tween.EASE_IN_OUT)


func fade_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"modulate:a", 0, 1) \
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	faded_out.emit()


func _on_button_restart_pressed() -> void:
	fade_out()
	await faded_out
	restarted.emit()


func _on_button_menu_pressed() -> void:
	fade_out()
	await faded_out
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
