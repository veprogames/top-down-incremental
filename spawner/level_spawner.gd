class_name LevelSpawner
extends Node

@onready var level: Level = get_tree().current_scene as Level
@onready var player: Player = get_tree().get_first_node_in_group(&"player") as Player


func _ready() -> void:
	assert(is_instance_valid(level) and is_instance_valid(player))


func is_lategame() -> bool:
	return level.time >= 1800


func get_tier(time: float) -> int:
	if is_lategame():
		return EnemyFactory.get_random_tier()
	return EnemyFactory.get_tier_for_time(level.time)


func create_enemy(time: float) -> Enemy:
	var tier: int = get_tier(level.time)
	var enemy: Enemy = EnemyFactory.create_random(tier)
	if is_lategame():
		enemy.hp = EnemyFactory.get_lategame_hp(time)
	return enemy


func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		var enemy: Enemy = create_enemy(level.time)
		
		var dist: float = randf_range(100, 500)
		var pos: Vector2 = player.position + dist * Vector2.RIGHT.rotated(randf() * TAU)
		
		var indicator: EnemySpawnIndicator = EnemySpawnIndicator.create(pos, enemy)
		
		level.add_child(indicator)
