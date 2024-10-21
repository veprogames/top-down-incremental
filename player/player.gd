class_name Player
extends CharacterBody2D

signal took_damage
signal died
@warning_ignore("unused_signal") # used for _on_gem_collected
signal gem_collected(color: Color)

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

var max_hp: int = 20
var hp: int

var gem_pitch: float = 0.8

# used for not calculating nearest enemy every physics frame
var cached_nearest_enemy: Enemy

@export var player_damage: PlayerDamage

@onready var bullet_pod_player: BulletPodPlayer = $BulletPodPlayer
@onready var auto_aim_area: AutoAimArea = $AutoAimArea
@onready var audio_stream_player_hurt: AudioStreamPlayer = $AudioStreamPlayerHurt


func _ready() -> void:
	hp = max_hp


func _unhandled_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_event:
		move_velocity += mouse_event.relative
	var touch_event: InputEventScreenDrag = event as InputEventScreenDrag
	if touch_event:
		move_velocity += touch_event.relative


func _process(delta: float) -> void:
	modulate = Color.RED if invincibility_timer > 0 else Color.WHITE
	
	gem_pitch = lerpf(gem_pitch, 0.8, 2 * delta)


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector(
		&"player_left",
		&"player_right",
		&"player_up",
		&"player_down"
	)
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * 15
		velocity /= 1 + Input.get_action_strength(&"player_move_slow")
		velocity *= 1 + Input.get_action_strength(&"player_move_fast")
	else:
		velocity = move_velocity
	velocity = velocity * MOVE_SPEED * Game.settings.sensitivity + secondary_velocity
	move_velocity = Vector2.ZERO
	
	# prevent jittering by only rotating at a min. velocity
	if velocity.length() > VELOCITY_THRESHOLD:
		target_rotation = velocity.angle()
	
	# faster smoothing at higher velocities to prevent rotation lagging behind
	rotation = lerp_angle(rotation, target_rotation, velocity.length() * delta * 0.1)
	
	secondary_velocity = secondary_velocity.lerp(Vector2.ZERO, SECONDARY_FRICTION * delta)
	
	move_and_slide()
	
	shoot_timer += get_current_firerate() * delta
	
	if shoot_timer >= 1.0:
		shoot_timer -= 1.0
		shoot.call_deferred()
	
	invincibility_timer = maxf(0.0, invincibility_timer - delta)


func get_input_shoot_vector() -> Vector2:
	return Input.get_vector(
		&"player_shoot_left",
		&"player_shoot_right",
		&"player_shoot_up",
		&"player_shoot_down"
	)


func get_current_firerate() -> float:
	var shoot_vector: Vector2 = get_input_shoot_vector()
	
	if shoot_vector != Vector2.ZERO:
		return 10
	
	var nearest: Enemy = cached_nearest_enemy
	
	if not is_instance_valid(nearest):
		return 5
	
	var distance: float = (nearest.global_position - global_position).length()
	var additional: float = clampf(
		remap(distance, 0, 200, 16, 0),
		0,
		15
	)
	return 5 + additional


func get_shoot_angle(target: Enemy) -> float:
	var shoot_vector: Vector2 = get_input_shoot_vector()
	
	if shoot_vector != Vector2.ZERO:
		return shoot_vector.angle()
	
	if is_instance_valid(target):
		return (target.global_position - global_position).angle()
	return rotation


func shoot() -> void:
	# recalculate cached nearest enemy only here
	cached_nearest_enemy = auto_aim_area.get_nearest_enemy()
	var bullet: BulletPlayer = bullet_pod_player.create_bullet()
	bullet.rotation = get_shoot_angle(cached_nearest_enemy)
	bullet.target_enemy = cached_nearest_enemy
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
	audio_stream_player_hurt.pitch_scale = 1.8 - hp / float(max_hp)
	audio_stream_player_hurt.play()
	
	if hp <= 0:
		died.emit()


func _on_died() -> void:
	queue_free()


func _on_gem_collected(color: Color) -> void:
	var html: String = color.to_html()
	player_damage.add_multiplier(html, 0.002)
	gem_pitch += 0.01
