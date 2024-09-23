class_name Enemy
extends Area2D

@export var hp: float = 1
@export var color: Color = Color.RED

@onready var level: Level = get_tree().current_scene as Level
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite: Sprite2D = $Visual/Sprite
@onready var sprite_shadow: Sprite2D = $Visual/SpriteShadow
@onready var visual: Node2D = $Visual

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
		deactivate()


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
	create_damage_number(amount)
	if current_hp <= 0:
		Events.enemy_died.emit(self)
		queue_free()
		spawn_gems.call_deferred()


func create_damage_number(dmg: float) -> void:
	var num: DamageNumber = DamageNumber.create(dmg)
	num.global_position = 0 * Vector2(
		randf_range(-8, 8),
		randf_range(-8, 8)
	) + global_position
	get_tree().current_scene.add_child(num)


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


func spawn_sparkle() -> Sparkle:
	var sparkle: Sparkle = Sparkle.create(Vector2.ZERO)
	add_child(sparkle)
	return sparkle


func activate() -> void:
	set_process(true)
	set_physics_process(true)
	visual.show()


func deactivate() -> void:
	set_process(false)
	set_physics_process(false)
	visual.hide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	deactivate()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	activate()


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		var dir: Vector2 = (position - player.position).normalized()
		var vec: Vector2 = -dir * (100 + velocity.length() * 4)
		player.try_knock(vec)


func _on_area_entered(area: Area2D) -> void:
	var auto_aim_area: AutoAimArea = area as AutoAimArea
	if auto_aim_area:
		auto_aim_area.add_enemy(self)
	
	var bullet: BulletPlayer = area as BulletPlayer
	if bullet:
		var sparkle: Sparkle = spawn_sparkle()
		sparkle.global_position = bullet.global_position + Vector2(
			randf_range(-4, 4),
			randf_range(-4, 4)
		)
		knockback_velocity += bullet.get_velocity().normalized() * 100
		bullet.queue_free()
		damage(bullet.damage)


func _on_area_exited(area: Area2D) -> void:
	var auto_aim_area: AutoAimArea = area as AutoAimArea
	if auto_aim_area:
		auto_aim_area.remove_enemy(self)
