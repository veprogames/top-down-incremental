class_name Bullet
extends Area2D

const SPEED_MULTIPLIER_BASE: float = 1.5
const SPEED_MULTIPLIER_ACCELERATION: float = 1.0

@export var base_speed: float = 0.0
var speed_multiplier: float = SPEED_MULTIPLIER_BASE

const MAX_TRAVEL_DISTANCE: float = 600.0
var travelled: float = 0.0

@export var damage: float = 1.0

@onready var sprite: Sprite2D = $Sprite


func _process(_delta: float) -> void:
	sprite.modulate.a = 1.0 - travelled
	if travelled >= 1.0:
		queue_free()


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
	if collision and "normal" in collision:
		@warning_ignore("unsafe_cast") # Assume Vector2
		var normal: Vector2 = collision.normal as Vector2
		assert(normal != null)
		var normal_angle: float = normal.angle() as float
		rotation += 2 * (normal_angle - rotation) + PI
	
	position += motion
	travelled += motion.length() / MAX_TRAVEL_DISTANCE
	
	speed_multiplier += SPEED_MULTIPLIER_ACCELERATION * delta
