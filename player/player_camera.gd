class_name PlayerCamera
extends Camera2D

const BASE_ZOOM: Vector2 = Vector2.ONE * 3

@onready var player: Player = get_tree().get_first_node_in_group(&"player")
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

var target_zoom: Vector2 = BASE_ZOOM
var target_offset: Vector2 = Vector2.ZERO
var current_offset: Vector2 = Vector2.ZERO
var shake_strength: float = 0.0


func _ready() -> void:
	assert(is_instance_valid(player))
	
	zoom = BASE_ZOOM * 10
	
	Events.enemy_died.connect(_on_events_enemy_died)
	player.took_damage.connect(_on_player_took_damage)


func _process(delta: float) -> void:
	if is_instance_valid(player):
		position = player.global_position
	
		var zoom_multi: float = remap(player.velocity.length(), 100, 2000, 1.0, 0.5)
		zoom_multi = clampf(zoom_multi, 0.5, 1.0)
		target_zoom = BASE_ZOOM * zoom_multi
		target_offset = player.velocity * 0.1
	
	zoom = zoom.lerp(target_zoom, 5 * delta)
	current_offset = current_offset.lerp(target_offset, 4 * delta)
	offset = current_offset + Vector2(randf(), randf()) * shake_strength
	shake_strength = lerpf(shake_strength, 0.0, 4 * delta)
	
	canvas_modulate.color = canvas_modulate.color.lerp(Color.WHITE, 4 * delta)


func _on_events_enemy_died(enemy: Enemy) -> void:
	shake_strength += 3.0
	canvas_modulate.color += enemy.color * 0.15


func _on_player_took_damage() -> void:
	shake_strength += 15.0
	canvas_modulate.color = Color.RED
	
