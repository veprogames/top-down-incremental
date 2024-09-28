class_name SceneSwitcher
extends Node

signal scene_changed

@onready var color_rect: ColorRect = $CanvasLayerOverlay/ColorRect

var locked: bool = false

func _change(scene: PackedScene) -> void:
	if locked:
		return
	
	locked = true
	
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, ^"color", Color.BLACK, 0.25) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func() -> void:
		get_tree().change_scene_to_packed(scene)
	)
	tween.tween_property(color_rect, ^"color", Color.BLACK * 0.0, 0.25) \
		.set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	locked = false
	
	scene_changed.emit()


func _quit() -> void:
	if locked:
		return
	
	locked = true
	
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, ^"color", Color.BLACK, 0.25) \
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	get_tree().quit()


# additional static functions with typing to circumvent inferred type warnings

static func change(scene: PackedScene) -> void:
	var node: SceneSwitcher = SceneSwitcherNode as SceneSwitcher
	node._change(scene)


static func quit() -> void:
	var node: SceneSwitcher = SceneSwitcherNode as SceneSwitcher
	node._quit()
