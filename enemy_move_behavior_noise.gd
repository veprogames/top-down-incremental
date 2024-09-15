class_name EnemyMoveBehaviorNoise
extends EnemyMoveBehavior

@export var speed: float = 1.0
@export var amplitude: float = 100.0

var noise: FastNoiseLite = preload("res://behavior/move_behavior_base_noise.tres").duplicate()

var t: float = 0.0


func _ready() -> void:
	noise.frequency *= speed
	noise.seed = randi()
	

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	t += delta
	
	velocity = Vector2(
		noise.get_noise_1d(t),
		noise.get_noise_1d(t + 1000)
	) * amplitude
