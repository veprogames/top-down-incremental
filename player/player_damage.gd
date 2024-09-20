class_name PlayerDamage
extends Node

signal damage_part_changed(key: String, value: float)

var _map: Dictionary = {}
var _damage: float = 10.0


func _ready() -> void:
	Events.enemy_died.connect(_on_global_enemy_died)


func get_damage() -> float:
	return _damage


func _calc_damage() -> void:
	var dmg: float = 10.0
	for v: float in _map.values():
		dmg *= v
	_damage = floorf(dmg)


func set_multiplier(color: String, multiplier: float) -> void:
	_map[color] = multiplier
	_calc_damage()
	damage_part_changed.emit(color, multiplier)


func add_multiplier(color: String, add: float) -> void:
	if color not in _map:
		_map[color] = 1.0
	assert(_map[color] is float)
	@warning_ignore("unsafe_cast")
	set_multiplier(color, (_map[color] as float) + add)


func _on_global_enemy_died(enemy: Enemy) -> void:
	var html: String = enemy.color.to_html()
	add_multiplier(html, 0.01)
