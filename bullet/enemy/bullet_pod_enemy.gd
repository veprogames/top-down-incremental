class_name BulletPodEnemy
extends BulletPod

signal timeout(bullet: BulletEnemy)

@export var firerate: float

@onready var enemy: Enemy = owner as Enemy
@onready var timer: Timer = $Timer


func _ready() -> void:
	assert(enemy != null)
	assert(firerate > 0)
	timer.wait_time = 1 / firerate


func _on_timer_timeout() -> void:
	timeout.emit(create_bullet())


func create_bullet() -> BulletEnemy:
	var bullet: BulletEnemy = super.create_bullet() as BulletEnemy
	bullet.base_speed = 125
	bullet.rotation = rotation
	return bullet
