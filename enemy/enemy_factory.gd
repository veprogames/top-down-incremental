class_name EnemyFactory
extends Object

static var Enemies: Array[PackedScene] = [
	preload("res://enemy/enemies/enemy_red.tscn"),
	preload("res://enemy/enemies/enemy_orange.tscn"),
	preload("res://enemy/enemies/enemy_yellow.tscn"),
	preload("res://enemy/enemies/enemy_green.tscn"),
]

static func create_random(tier: int) -> Enemy:
	assert(tier >= 0 and tier < Enemies.size())
	
	var enemy: Enemy = Enemies[tier].instantiate() as Enemy
	
	return enemy
