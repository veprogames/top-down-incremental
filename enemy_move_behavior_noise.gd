class_name EnemyMoveBehaviorNoise
extends EnemyMoveBehavior

@export var speed: float = 1.0
@export var amplitude: float = 100.0

var noise: FastNoiseLite = preload("res://behavior/move_behavior_base_noise.tres").duplicate()

var t: float = 0.0


func _ready() -> void:
	noise.frequency *= speed
	noise.seed = randi()


func _process(delta: float) -> void:
	super._process(delta)
	
	t += delta


func recalculate_velocity() -> void:
	super.recalculate_velocity()
	
	velocity = Vector2(
		noise.get_noise_1d(t),
		noise.get_noise_1d(t + 1000)
	) * amplitude
