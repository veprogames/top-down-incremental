class_name Spawner
extends StaticBody2D

var EnemyScene: PackedScene = preload("res://enemy/enemy.tscn")

func _on_timer_timeout() -> void:
	var enemy: Enemy = EnemyFactory.create_random(((3 if randf() < 0.2 else 2) if randf() < 0.2 else 1) if randf() < 0.2 else 0)
	enemy.position = Vector2(
		randf_range(-50.0, 50.0),
		randf_range(-50.0, 50.0)
	) + global_position
	owner.add_child(enemy)
