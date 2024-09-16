class_name PlayerCamera
extends Camera2D

const BASE_ZOOM: Vector2 = Vector2.ONE * 3

@export var player: Player

var target_zoom: Vector2 = BASE_ZOOM
var target_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	zoom = BASE_ZOOM * 10


func _physics_process(delta: float) -> void:
	var zoom_multi: float = remap(player.velocity.length(), 100, 2000, 1.0, 0.5)
	zoom_multi = clampf(zoom_multi, 0.5, 1.0)
	target_zoom = BASE_ZOOM * zoom_multi
	target_offset = player.velocity * 0.1
	
	zoom = zoom.lerp(target_zoom, 5 * delta)
	offset = offset.lerp(target_offset, 4 * delta)
