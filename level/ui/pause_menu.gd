class_name PauseMenu
extends Panel

static var Scene: PackedScene = preload("res://level/ui/pause_menu.tscn")

@onready var tree: SceneTree = get_tree()

var previous_mouse_mode: Input.MouseMode


func _ready() -> void:
	previous_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	tree.paused = true
	
	scale = Vector2.ZERO
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_ELASTIC)


func _on_button_continue_pressed() -> void:
	Input.mouse_mode = previous_mouse_mode
	tree.paused = false
	queue_free()


func _on_button_main_menu_pressed() -> void:
	tree.paused = false
	tree.change_scene_to_file("res://main_menu/main_menu.tscn")


static func create() -> PauseMenu:
	return Scene.instantiate()
