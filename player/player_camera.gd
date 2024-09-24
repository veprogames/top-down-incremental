class_name PlayerCamera
extends Camera2D

const BASE_ZOOM: Vector2 = Vector2.ONE * 3

@onready var player: Player = get_tree().get_first_node_in_group(&"player")

var target_zoom: Vector2 = BASE_ZOOM
var target_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	assert(is_instance_valid(player))
	
	zoom = BASE_ZOOM * 10


func _process(delta: float) -> void:
	if is_instance_valid(player):
		position = player.global_position
	
		var zoom_multi: float = remap(player.velocity.length(), 100, 2000, 1.0, 0.5)
		zoom_multi = clampf(zoom_multi, 0.5, 1.0)
		target_zoom = BASE_ZOOM * zoom_multi
		target_offset = player.velocity * 0.1
	
	zoom = zoom.lerp(target_zoom, 5 * delta)
	offset = offset.lerp(target_offset, 4 * delta)
