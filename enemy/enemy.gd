class_name Enemy
extends CharacterBody2D

@export var hp: float = 10
var current_hp: float = hp

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area is Bullet:
		area.queue_free()
		current_hp -= 1
		if current_hp <= 0:
			queue_free()
