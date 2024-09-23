class_name BulletPlayer
extends Bullet

const HOMING: float = PI
const MAX_TRAVEL_DISTANCE: float = 600.0

@export var damage: float = 1.0

var target_enemy: Enemy

var travelled: float = 0.0

const SPEED_MULTIPLIER_BASE: float = 1.5
const SPEED_MULTIPLIER_ACCELERATION: float = 1.0
var speed_multiplier: float = SPEED_MULTIPLIER_BASE

var physics_frame: int = 0


func _process(_delta: float) -> void:
	animated_sprite.modulate.a = min(1.0, 2.0 * (1.0 - travelled))
	if travelled >= 1.0:
		queue_free()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	physics_frame += 1
	
	var motion: Vector2 = get_velocity() * delta
	
	if physics_frame % 8 == 0:
		# bounce on walls
		var ray_cast_result: Utils.RayCastResult = Utils.cast_ray(self, motion.normalized() * 8, 0b100)
		if ray_cast_result:
			var normal: Vector2 = ray_cast_result.normal
			var normal_angle: float = normal.angle() as float
			rotation += 2 * (normal_angle - rotation) + PI
	
	# homing
	if is_instance_valid(target_enemy):
		var target_rotation: float = (target_enemy.global_position - global_position).angle()
		rotation = rotate_toward(rotation, target_rotation, HOMING * delta)
	
	speed_multiplier += SPEED_MULTIPLIER_ACCELERATION * delta
	
	travelled += motion.length() / MAX_TRAVEL_DISTANCE


func get_velocity() -> Vector2:
	return super.get_velocity() * speed_multiplier
