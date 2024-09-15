class_name Enemy
extends CharacterBody2D

@export var hp: float = 1
@export var color: Color = Color.RED
var current_hp: float = hp

var move_behaviors: Array[EnemyMoveBehavior]

func _ready() -> void:
	move_behaviors.assign(Utils.get_children_of_group(self, "enemy_move_behavior"))


func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	for behavior: EnemyMoveBehavior in move_behaviors:
		velocity += behavior.velocity
	
	rotation = velocity.angle()
	
	move_and_slide()


func _on_hit_area_area_entered(area: Area2D) -> void:
	var bullet: Bullet = area as Bullet
	if bullet:
		area.queue_free()
		current_hp -= bullet.damage
		if current_hp <= 0:
			Events.enemy_died.emit(self)
			queue_free()
