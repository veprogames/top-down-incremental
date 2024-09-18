class_name BulletEnemy
extends Bullet


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		var knockback_velocity: Vector2 = get_velocity().normalized() * 300
		player.try_knock(knockback_velocity)
