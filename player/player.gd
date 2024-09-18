class_name Player
extends CharacterBody2D

signal took_damage
signal died

var BulletScene: PackedScene = preload("res://bullet/bullet.tscn")

var move_velocity: Vector2 = Vector2.ZERO
const MOVE_SPEED: float = 50.0
const VELOCITY_THRESHOLD: float = 12.0

# used for knockback
var secondary_velocity: Vector2 = Vector2.ZERO
const SECONDARY_FRICTION: float = 3

var target_rotation: float = 0.0

var shoot_timer: float = 0.0

var invincibility_timer: float = 0.0

var hp: int = 10

@export var player_damage: PlayerDamage

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_event:
		move_velocity += mouse_event.relative * MOVE_SPEED


func _process(_delta: float) -> void:
	modulate = Color.RED if invincibility_timer > 0 else Color.WHITE


func _physics_process(delta: float) -> void:
	velocity = move_velocity + secondary_velocity
	move_velocity = Vector2.ZERO
	
	var additional_firerate: float = 0.0125 * velocity.length()
	shoot_timer += (5 + additional_firerate) * delta
	
	# prevent jittering by only rotating at a min. velocity
	if velocity.length() > VELOCITY_THRESHOLD:
		target_rotation = velocity.angle()
	
	# faster smoothing at higher velocities to prevent rotation lagging behind
	rotation = lerp_angle(rotation, target_rotation, velocity.length() * delta * 0.1)
	
	secondary_velocity = secondary_velocity.lerp(Vector2.ZERO, SECONDARY_FRICTION * delta)
	
	move_and_slide()
	
	if shoot_timer >= 1.0:
		shoot_timer -= 1.0
		shoot.call_deferred()
	
	invincibility_timer = maxf(0.0, invincibility_timer - delta)


func shoot() -> void:
	var bullet: Bullet = BulletScene.instantiate() as Bullet
	bullet.position = global_position
	bullet.rotation = rotation
	bullet.damage = player_damage.get_damage()
	bullet.base_speed = velocity.length() + 100
	owner.add_child(bullet)


func try_knock(vec: Vector2) -> void:
	if can_get_hit():
		secondary_velocity += vec
		took_damage.emit()


func can_get_hit() -> bool:
	return invincibility_timer <= 0.0


func _on_took_damage() -> void:
	hp -= 1
	invincibility_timer = 1.0
	
	if hp <= 0:
		died.emit()


func _on_died() -> void:
	queue_free()
