class_name LevelSpawner
extends Node

@onready var level: Level = get_tree().current_scene as Level
@onready var player: Player = get_tree().get_first_node_in_group(&"player") as Player
@onready var timer: Timer = $Timer


func _ready() -> void:
	assert(is_instance_valid(level) and is_instance_valid(player))
	
	timer.wait_time = get_spawn_interval(level.time)


func get_spawn_interval(level_time: float) -> float:
	if is_lategame():
		return 1.0 / 4.0
	return 1.0 / clampf(
		1.6 + 0.001 * (level_time - 300),
		1.6,
		3.0
	)


func is_lategame() -> bool:
	return EnemyFactory.is_lategame(level.time)


func get_tier(time: float) -> int:
	if is_lategame():
		return EnemyFactory.get_random_tier()
	return EnemyFactory.get_tier_for_time(level.time)


func create_enemy(time: float) -> Enemy:
	var tier: int = get_tier(level.time)
	var enemy: Enemy = EnemyFactory.create_random(tier)
	if is_lategame():
		enemy.hp = EnemyFactory.get_lategame_base_hp(time) * (1.0 + tier) * randf_range(0.8, 1.2)
	return enemy


func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		var enemy: Enemy = create_enemy(level.time)
		
		var dist: float = randf_range(100, 500)
		var pos: Vector2 = player.position + dist * Vector2.RIGHT.rotated(randf() * TAU)
		
		var indicator: EnemySpawnIndicator = EnemySpawnIndicator.create(pos, enemy)
		
		level.add_child(indicator)
		
		timer.wait_time = get_spawn_interval(level.time)
