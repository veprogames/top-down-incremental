class_name EnemySpawnIndicator
extends Node2D

static var SpawnIndicatorScene: PackedScene = preload("res://spawner/enemy_spawn_indicator.tscn")

var attempts: int = 8

var enemy: Enemy

var did_spawn: bool = false

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var level: Level = get_tree().current_scene as Level
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	assert(is_instance_valid(level))
	
	shape_cast_2d.force_shapecast_update()
	while is_instance_valid(shape_cast_2d) and shape_cast_2d.get_collision_count() > 0:
		position += 100 * Vector2.RIGHT.rotated(randf() * TAU)
		# world boundaries are not detected for some reason
		position = position.clampf(-1000, 1000)
		
		attempts -= 1
		if attempts == 0:
			break
			queue_free()
		
		shape_cast_2d.force_shapecast_update()
	
	shape_cast_2d.queue_free()
	animated_sprite_2d.play(&"default")


func spawn() -> void:
	if is_instance_valid(enemy):
		enemy.global_position = global_position
		level.add_enemy(enemy)


static func create(pos: Vector2, enemy_: Enemy) -> EnemySpawnIndicator:
	var indicator: EnemySpawnIndicator = SpawnIndicatorScene.instantiate() as EnemySpawnIndicator
	indicator.global_position = pos
	indicator.enemy = enemy_
	return indicator


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.frame == 12 and not did_spawn:
		spawn()
		did_spawn = true


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
