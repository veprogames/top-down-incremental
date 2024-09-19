class_name BulletPlayer
extends Bullet

const HOMING: float = PI

@export var damage: float = 1.0

var target_enemy: Enemy


func _process(delta: float) -> void:
	super._process(delta)
	
	animated_sprite.modulate.a = min(1.0, 2.0 * (1.0 - travelled))


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_instance_valid(target_enemy):
		var target_rotation: float = (target_enemy.global_position - global_position).angle()
		rotation = rotate_toward(rotation, target_rotation, HOMING * delta)
