class_name BulletEnemy
extends Bullet

const COLLISION_MASK_WALL: int = 0b100


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		var knockback_velocity: Vector2 = get_velocity().normalized() * 300
		player.try_knock(knockback_velocity)


func _on_area_entered(_area: Area2D) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
