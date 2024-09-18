class_name BulletPodPlayer
extends BulletPod

@export var player: Player


func create_bullet() -> BulletPlayer:
	var bullet: BulletPlayer = super.create_bullet() as BulletPlayer
	bullet.damage = player.player_damage.get_damage()
	bullet.base_speed = player.velocity.length() + 100
	return bullet
