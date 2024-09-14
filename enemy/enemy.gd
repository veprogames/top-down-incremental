class_name Enemy
extends CharacterBody2D

@export var hp: float = 10
var current_hp: float = hp

@export var noise: FastNoiseLite

var t: float = 0


func _ready() -> void:
	noise = noise.duplicate()
	noise.seed = randi()


func _physics_process(delta: float) -> void:
	t += delta
	velocity = Vector2(
		noise.get_noise_1d(t),
		noise.get_noise_1d(t + 1000)
	) * 100
	move_and_slide()


func _on_hit_area_area_entered(area: Area2D) -> void:
	if area is Bullet:
		area.queue_free()
		current_hp -= 1
		if current_hp <= 0:
			queue_free()
