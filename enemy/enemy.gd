class_name Enemy
extends Area2D

@export var hp: float = 1
@export var color: Color = Color.RED
var current_hp: float

var move_behaviors: Array[EnemyMoveBehavior]

var velocity: Vector2
var knockback_velocity: Vector2 = Vector2.ZERO
const KNOCKBACK_FRICTION: float = 2


func _ready() -> void:
	current_hp = hp
	move_behaviors.assign(Utils.get_children_of_type(self, EnemyMoveBehavior))


func _physics_process(delta: float) -> void:
	velocity = knockback_velocity
	
	for behavior: EnemyMoveBehavior in move_behaviors:
		velocity += behavior.velocity
	
	rotation = velocity.angle()
	
	position += velocity * delta
	
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, delta * KNOCKBACK_FRICTION)


func damage(amount: float) -> void:
	current_hp -= amount
	if current_hp <= 0:
		Events.enemy_died.emit(self)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_process(false)
	set_physics_process(false)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_process(true)
	set_physics_process(true)


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		var dir: Vector2 = (position - player.position).normalized()
		var vec: Vector2 = -dir * (100 + velocity.length() * 4)
		player.try_knock(vec)


func _on_area_entered(area: Area2D) -> void:
	var bullet: Bullet = area as Bullet
	if bullet:
		bullet.queue_free()
		damage(bullet.damage)
