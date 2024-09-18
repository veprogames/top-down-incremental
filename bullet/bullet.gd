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
	
	var ray_cast_result: Utils.RayCastResult = Utils.cast_ray(self, motion, 0b100)
	if ray_cast_result:
		var normal: Vector2 = ray_cast_result.normal
		var normal_angle: float = normal.angle() as float
		rotation += 2 * (normal_angle - rotation) + PI
	
	position += motion
	travelled += motion.length() / MAX_TRAVEL_DISTANCE
	
	speed_multiplier += SPEED_MULTIPLIER_ACCELERATION * delta
