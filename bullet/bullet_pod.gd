class_name BulletPod
extends Node2D

@export var bullet_scene: PackedScene


func create_bullet() -> Bullet:
	var bullet: Bullet = bullet_scene.instantiate() as Bullet
	bullet.position = global_position
	bullet.rotation = global_rotation
	return bullet
