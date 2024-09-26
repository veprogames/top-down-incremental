class_name Gem
extends Area2D

static var GemScene: PackedScene = preload("res://gem/gem.tscn")
static var stream_collect: AudioStream = preload("res://gem/collect.ogg")

const FRICTION: float = 3

const COLLISION_LAYER_MAGNET: int = 0b10_0000

var velocity: Vector2 = Vector2.ZERO

## attracted by this node
var magnet: Node2D

@export var color: Color : set = _set_color

@onready var sprite_2d: Sprite2D = %Sprite
@onready var visual: Node2D = $Visual
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	set_process_input(false)


func _set_color(col: Color) -> void:
	if not is_node_ready():
		await ready
	sprite_2d.modulate = col
	color = col


func _physics_process(delta: float) -> void:
	position += velocity * delta
	
	if is_instance_valid(magnet):
		var distance: Vector2 = magnet.global_position - global_position
		var speed: float = 50_000.0 / distance.length_squared()
		velocity += (distance).normalized() * speed
	
	velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		player.gem_collected.emit(color)
		GlobalSound.play(Gem.stream_collect, player.gem_pitch)
		create_sparkle()
		queue_free()


func create_sparkle() -> void:
	var sparkle_: Sparkle = Sparkle.create(global_position)
	sparkle_.modulate = color
	get_tree().current_scene.add_child(sparkle_)


static func create_with_velocity(col: Color, vel: Vector2) -> Gem:
	var gem: Gem = Gem.GemScene.instantiate()
	gem.color = col
	gem.velocity = vel
	return gem


func activate() -> void:
	set_process(true)
	set_physics_process(true)
	visual.show()
	monitoring = true
	collision_shape_2d.disabled = false


func deactivate() -> void:
	set_process(false)
	set_physics_process(false)
	visual.hide()
	monitoring = false
	collision_shape_2d.disabled = true


func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer & COLLISION_LAYER_MAGNET:
		magnet = area


func _on_area_exited(area: Area2D) -> void:
	if area.collision_layer & COLLISION_LAYER_MAGNET:
		magnet = null


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	activate()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	deactivate()
