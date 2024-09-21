class_name EnemyFactory
extends Object

static var Enemies: Array[PackedScene] = [
	preload("res://enemy/enemies/enemy_red.tscn"),
	preload("res://enemy/enemies/enemy_orange.tscn"),
	preload("res://enemy/enemies/enemy_yellow.tscn"),
	preload("res://enemy/enemies/enemy_green.tscn"),
	preload("res://enemy/enemies/enemy_cyan.tscn"),
	preload("res://enemy/enemies/enemy_blue.tscn"),
	preload("res://enemy/enemies/enemy_purple.tscn"),
	preload("res://enemy/enemies/enemy_magenta.tscn"),
	preload("res://enemy/enemies/enemy_white.tscn"),
	preload("res://enemy/enemies/enemy_black.tscn"),
]


static func get_random_tier(level_time: float) -> int:
	var bias: float = clampf(-log(randf()) / log(5), 0, 3)
	var tier: int = int(level_time / 180 + bias - 0.5)
	return clampi(tier, 0, Enemies.size() - 1)


static func create_random(tier: int) -> Enemy:
	assert(tier >= 0 and tier < Enemies.size())
	
	var enemy: Enemy = Enemies[tier].instantiate() as Enemy
	
	return enemy
