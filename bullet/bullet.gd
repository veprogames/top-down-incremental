class_name Bullet
extends Area2D

const SPEED_MULTIPLIER_BASE: float = 1.5
@export var speed_multiplier_acceleration: float = 0.0

@export var base_speed: float = 0.0
var speed_multiplier: float = SPEED_MULTIPLIER_BASE

const MAX_TRAVEL_DISTANCE: float = 600.0
var travelled: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite


func _process(_delta: float) -> void:
	if travelled >= 1.0:
		queue_free()


func _physics_process(delta: float) -> void:
	var motion: Vector2 = get_velocity() * delta
	
	var ray_cast_result: Utils.RayCastResult = Utils.cast_ray(self, motion, 0b100)
	if ray_cast_result:
		var normal: Vector2 = ray_cast_result.normal
		var normal_angle: float = normal.angle() as float
		rotation += 2 * (normal_angle - rotation) + PI
	
	position += motion
	travelled += motion.length() / MAX_TRAVEL_DISTANCE
	
	speed_multiplier += speed_multiplier_acceleration * delta


func get_velocity() -> Vector2:
	var motion: Vector2 = Vector2.RIGHT.rotated(rotation)
	motion *= base_speed * speed_multiplier
	return motion
