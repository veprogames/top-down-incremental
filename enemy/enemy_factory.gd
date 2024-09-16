class_name EnemyFactory
extends Object

static var BehaviorChaseScene: PackedScene = preload("res://behavior/enemy_move_behavior_chase.tscn")
static var BehaviorNoiseScene: PackedScene = preload("res://behavior/enemy_move_behavior_noise.tscn")

static var Enemies: Array[PackedScene] = [
	preload("res://enemy/enemies/enemy_red.tscn"),
	preload("res://enemy/enemies/enemy_orange.tscn"),
	preload("res://enemy/enemies/enemy_yellow.tscn"),
	preload("res://enemy/enemies/enemy_green.tscn"),
]

static func create_random(tier: int) -> Enemy:
	assert(tier >= 0 and tier < Enemies.size())
	
	var enemy: Enemy = Enemies[tier].instantiate() as Enemy
	var behavior_chase: EnemyMoveBehaviorChase = BehaviorChaseScene.instantiate() as EnemyMoveBehaviorChase
	var behavior_noise: EnemyMoveBehaviorNoise = BehaviorNoiseScene.instantiate() as EnemyMoveBehaviorNoise
	
	behavior_chase.speed = randf_range(0, 100)
	behavior_chase.enemy = enemy
	behavior_noise.speed = randf_range(0.5, 2)
	behavior_noise.amplitude = randf_range(0, 400)
	behavior_noise.enemy = enemy
	
	enemy.add_child(behavior_chase)
	enemy.add_child(behavior_noise)
	
	return enemy
