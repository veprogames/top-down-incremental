class_name BulletPodPlayer
extends BulletPod

@onready var player: Player = owner as Player

var t: float = 0.0
var last_shoot_time: float = 0.0


func _ready() -> void:
	assert(player != null)


func _process(delta: float) -> void:
	t += delta


func create_bullet() -> BulletPlayer:
	var bullet: BulletPlayer = super.create_bullet() as BulletPlayer
	bullet.damage = player.player_damage.get_damage()
	bullet.base_speed = player.velocity.length() + 100
	bullet.set_pitch(remap(
		t - last_shoot_time,
		0, 0.2,
		2, 0.7
	))
	last_shoot_time = t
	return bullet
