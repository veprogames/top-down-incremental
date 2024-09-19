class_name EnemyMoveBehavior
extends BaseBehavior

@onready var enemy: Enemy = owner as Enemy

var velocity: Vector2

## framerate dependent (for ease) recalculate counter
var refresh_counter: int = 0


func _ready() -> void:
	assert(enemy != null)


func _process(_delta: float) -> void:
	refresh_counter += 1
	if refresh_counter > 7:
		refresh_counter = 0
		recalculate_velocity()


func recalculate_velocity() -> void:
	pass


func mutate() -> void:
	super.mutate()
