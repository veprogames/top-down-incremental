class_name MenuBackground
extends Node2D


var target_position: Vector2
var viewport_rect: Rect2


func _ready() -> void:
	viewport_rect = get_viewport_rect()
	target_position = viewport_rect.size / 2
	position = target_position


func _process(delta: float) -> void:
	target_position = 0.25 * (viewport_rect.size / 2 - get_global_mouse_position()) + viewport_rect.size / 2
	position = position.lerp(target_position, delta)
