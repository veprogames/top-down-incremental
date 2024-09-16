class_name EnemyMoveBehaviorChase
extends EnemyMoveBehavior

var player: Player

@export var speed: float = 100.0


func _ready() -> void:
	player = get_tree().get_first_node_in_group(&"player")


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	assert(enemy != null)
	
	if player:
		velocity = (player.position - enemy.position).normalized() * speed
	else:
		velocity = Vector2.ZERO
