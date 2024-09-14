class_name Player
extends CharacterBody2D

var accumulated_motion: Vector2 = Vector2.ZERO
const MOVE_SPEED: float = 400.0

var target_rotation: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_event:
		accumulated_motion += mouse_event.relative * MOVE_SPEED


func _physics_process(delta: float) -> void:
	velocity = accumulated_motion
	accumulated_motion = Vector2.ZERO
	
	# prevent jittering by only rotating at a min. velocity
	if velocity.length() > 100:
		target_rotation = velocity.angle()
	
	# faster smoothing at higher velocities to prevent rotation lagging behind
	rotation = lerp_angle(rotation, target_rotation, velocity.length() * delta * 0.01)
	
	move_and_slide()
