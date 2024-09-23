class_name AutoAimArea
extends Area2D

var nearby_enemies: Array[Enemy] = []


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)


func get_nearest_enemy() -> Enemy:
	var smallest_dist: float = INF
	var nearest: Enemy = null
	for enemy: Enemy in nearby_enemies:
		if not is_instance_valid(enemy):
			continue
		
		var dist: float = global_position.distance_squared_to(enemy.global_position)
		if dist < smallest_dist:
			nearest = enemy
			smallest_dist = dist
	return nearest


func add_enemy(enemy: Enemy) -> void:
	nearby_enemies.append(enemy)


func remove_enemy(enemy: Enemy) -> void:
	nearby_enemies.erase(enemy)


func _on_enemy_died(enemy: Enemy) -> void:
	remove_enemy(enemy)
