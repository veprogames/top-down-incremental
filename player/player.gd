class_name Player
extends CharacterBody2D

var BulletScene: PackedScene = preload("res://bullet/bullet.tscn")

var accumulated_motion: Vector2 = Vector2.ZERO
const MOVE_SPEED: float = 50.0
const VELOCITY_THRESHOLD: float = 12.0

var target_rotation: float = 0.0

var shoot_timer: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_event:
		accumulated_motion += mouse_event.relative * MOVE_SPEED


func _physics_process(delta: float) -> void:
	velocity = accumulated_motion
	accumulated_motion = Vector2.ZERO
	
	shoot_timer += velocity.length() / 7_500
	
	# prevent jittering by only rotating at a min. velocity
	if velocity.length() > VELOCITY_THRESHOLD:
		target_rotation = velocity.angle()
	
	# faster smoothing at higher velocities to prevent rotation lagging behind
	rotation = lerp_angle(rotation, target_rotation, velocity.length() * delta * 0.1)
	
	move_and_slide()
	
	if shoot_timer >= 1.0:
		shoot_timer -= 1.0
		if velocity.length() > VELOCITY_THRESHOLD:
			shoot.call_deferred()


func shoot() -> void:
	var bullet: Bullet = BulletScene.instantiate() as Bullet
	bullet.position = global_position
	bullet.rotation = rotation
	bullet.base_speed = velocity.length()
	owner.add_child(bullet)
