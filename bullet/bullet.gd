class_name Bullet
extends Area2D

const SPEED_MULTIPLIER_BASE: float = 2.0
const SPEED_MULTIPLIER_ACCELERATION: float = 1.0

@export var base_speed: float = 0.0
var speed_multiplier: float = SPEED_MULTIPLIER_BASE

func _physics_process(delta: float) -> void:
	var motion: Vector2 = Vector2.RIGHT.rotated(rotation)
	motion *= base_speed * speed_multiplier * delta
	
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		position,
		position + motion,
		0b100
	)
	var collision: Dictionary = space_state.intersect_ray(query)
	if collision:
		var normal_angle: float = collision.normal.angle() as float
		rotation += 2 * (normal_angle - rotation) + PI
	
	position += motion
	
	speed_multiplier += SPEED_MULTIPLIER_ACCELERATION * delta
