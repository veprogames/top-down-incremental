class_name EnemyVisuals
extends Node2D

@export var texture: Texture2D

@onready var enemy: Enemy = owner as Enemy

var tex_size: Vector2

var health_bar_alpha: float = -2.0
var health_bar_rect: Rect2
var health_bar_fill_rect: Rect2
var health_bar_fill_amount: float = 1.0


func _ready() -> void:
	assert(is_instance_valid(enemy))
	
	tex_size = texture.get_size()
	health_bar_fill_rect = Rect2(Vector2(-12, -8 - tex_size.y / 2), Vector2(24, 2))
	health_bar_rect = health_bar_fill_rect.grow(2.0)
	
	enemy.current_hp_changed.connect(_on_enemy_current_hp_changed)


func _process(delta: float) -> void:
	health_bar_alpha = clampf(health_bar_alpha - delta * 1.25, -2.0, 2.0)
	
	if health_bar_alpha >= 0:
		queue_redraw()


func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE * 1.1)
	draw_texture(texture, -tex_size * 0.5, Color.BLACK * 0.5)
	draw_set_transform(Vector2.ZERO, 0)
	draw_texture(texture, -tex_size * 0.5)
	
	if health_bar_alpha > 0:
		draw_set_transform(Vector2.ZERO, -rotation)
		draw_rect(health_bar_rect, Color.BLACK * health_bar_alpha)
		
		var fill_rect: Rect2 = Rect2(
			health_bar_fill_rect.position,
			Vector2(health_bar_fill_rect.size.x * health_bar_fill_amount, health_bar_fill_rect.size.y)
		)
		draw_rect(fill_rect, Color.WHITE * health_bar_alpha)


func _on_enemy_current_hp_changed(hp: float) -> void:
	health_bar_fill_amount = hp / enemy.hp
	health_bar_alpha += 0.5
