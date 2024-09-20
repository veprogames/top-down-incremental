class_name Bullet
extends Area2D

@export var base_speed: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite


func _physics_process(delta: float) -> void:
	var motion: Vector2 = get_velocity() * delta
	
	position += motion


func get_velocity() -> Vector2:
	var motion: Vector2 = Vector2.RIGHT.rotated(rotation)
	motion *= base_speed
	return motion
