class_name LevelSpawner
extends Node

@onready var level: Level = get_tree().current_scene as Level
@onready var player: Player = get_tree().get_first_node_in_group(&"player") as Player


func _ready() -> void:
	assert(is_instance_valid(level) and is_instance_valid(player))


func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		var tier: int = EnemyFactory.get_random_tier(level.time)
		var enemy: Enemy = EnemyFactory.create_random(tier)
		enemy.position = player.position + 500 * Vector2.RIGHT.rotated(randf() * TAU)
		level.add_enemy(enemy)
