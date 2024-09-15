class_name Enemy
extends CharacterBody2D

@export var hp: float = 1
@export var color: Color = Color.RED
var current_hp: float = hp

func _on_hit_area_area_entered(area: Area2D) -> void:
	var bullet: Bullet = area as Bullet
	if bullet:
		area.queue_free()
		current_hp -= bullet.damage
		if current_hp <= 0:
			Events.enemy_died.emit(self)
			queue_free()
