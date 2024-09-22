class_name Enemy
extends Area2D

@export var hp: float = 1
@export var color: Color = Color.RED

@onready var level: Level = get_tree().current_scene as Level
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite: Sprite2D = $Sprite
@onready var sprite_shadow: Sprite2D = $SpriteShadow

var current_hp: float

var move_behaviors: Array[EnemyMoveBehavior]
var bullet_pods: Array[BulletPodEnemy]

var velocity: Vector2
var knockback_velocity: Vector2 = Vector2.ZERO
const KNOCKBACK_FRICTION: float = 2

func _ready() -> void:
	assert(is_instance_valid(level))
	
	current_hp = hp
	move_behaviors.assign(Utils.get_children_of_type(self, EnemyMoveBehavior))
	
	for behavior: EnemyMoveBehavior in move_behaviors:
		behavior.mutate()
	
	for pod: BulletPodEnemy in Utils.get_children_of_type(self, BulletPod):
		pod.timeout.connect(shoot)
	
	sprite_shadow.texture = sprite.texture
	sprite_shadow.position.y = sprite.texture.get_height() / 16.0
	
	if not visible_on_screen_notifier_2d.is_on_screen():
		set_process(false)
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	for behavior: EnemyMoveBehavior in move_behaviors:
		velocity += behavior.velocity
	
	var total_velocity: Vector2 = velocity + knockback_velocity
	
	var motion: Vector2 = total_velocity * delta
	
	var angle: float = velocity.angle()
	sprite.rotation = angle
	sprite_shadow.rotation = angle
	
	position += motion
	
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, delta * KNOCKBACK_FRICTION)
	
	# check collision with walls
	# can rarely glitch out on concave edges
	var raycast_result: Utils.RayCastResult = Utils.cast_ray(self, motion.normalized() * 8, 0b100)
	if raycast_result:
		var knockback: Vector2 = raycast_result.normal * 400
		knockback_velocity += knockback


func damage(amount: float) -> void:
	current_hp -= amount
	if current_hp <= 0:
		Events.enemy_died.emit(self)
		queue_free()
		spawn_gems.call_deferred()


func shoot(bullet: BulletEnemy) -> void:
	get_tree().current_scene.add_child(bullet)


func spawn_gems() -> void:
	var count: int = randi_range(4, 8)
	for i: int in count:
		var vel: Vector2 = velocity.normalized() * randf_range(30, 70)
		vel += velocity * randf_range(0.5, 1.5)
		vel *= -1
		vel = vel.rotated(randf_range(-PI / 6, PI / 6))
		
		var gem: Gem = Gem.create_with_velocity(color, vel)
		gem.position = global_position
		level.add_gem(gem)


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
	var bullet: BulletPlayer = area as BulletPlayer
	if bullet:
		knockback_velocity += bullet.get_velocity().normalized() * 100
		bullet.queue_free()
		damage(bullet.damage)
