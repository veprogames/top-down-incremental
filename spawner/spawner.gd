class_name Spawner
extends StaticBody2D

var EnemyScene: PackedScene = preload("res://enemy/enemy.tscn")

func _on_timer_timeout() -> void:
	var enemy: Enemy = EnemyScene.instantiate() as Enemy
	enemy.position = Vector2(
		randf_range(-50.0, 50.0),
		randf_range(-50.0, 50.0)
	) + global_position
	owner.add_child(enemy)
