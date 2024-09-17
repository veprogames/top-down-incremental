class_name Enemy
extends CharacterBody2D

@export var hp: float = 1
@export var color: Color = Color.RED
var current_hp: float

var move_behaviors: Array[EnemyMoveBehavior]

func _ready() -> void:
	current_hp = hp
	move_behaviors.assign(Utils.get_children_of_type(self, EnemyMoveBehavior))


func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	for behavior: EnemyMoveBehavior in move_behaviors:
		velocity += behavior.velocity
	
	rotation = velocity.angle()
	
	move_and_slide()


func damage(amount: float) -> void:
	current_hp -= amount
	if current_hp <= 0:
		Events.enemy_died.emit(self)
		queue_free()
