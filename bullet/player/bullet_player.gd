class_name BulletPlayer
extends Bullet

@export var damage: float = 1.0


func _process(delta: float) -> void:
	super._process(delta)
	
	animated_sprite.modulate.a = min(1.0, 2.0 * (1.0 - travelled))
