class_name Gem
extends Area2D

static var GemScene: PackedScene = preload("res://gem/gem.tscn")

const FRICTION: float = 3

const COLLISION_LAYER_MAGNET: int = 0b10_0000

var velocity: Vector2 = Vector2.ZERO

## attracted by this node
var magnet: Node2D

@export var color: Color : set = _set_color

@onready var sprite_2d: Sprite2D = $Sprite2D


func _set_color(col: Color) -> void:
	if not is_node_ready():
		await ready
	sprite_2d.modulate = col
	color = col


func _physics_process(delta: float) -> void:
	position += velocity * delta
	
	if is_instance_valid(magnet):
		var distance: Vector2 = magnet.global_position - global_position
		var speed: float = 20000.0 / distance.length_squared()
		velocity += (distance).normalized() * speed
	
	velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		player.gem_collected.emit(color)
		queue_free()


static func create_with_velocity(col: Color, vel: Vector2) -> Gem:
	var gem: Gem = Gem.GemScene.instantiate()
	gem.color = col
	gem.velocity = vel
	return gem


func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer & COLLISION_LAYER_MAGNET:
		magnet = area


func _on_area_exited(area: Area2D) -> void:
	if area.collision_layer & COLLISION_LAYER_MAGNET:
		magnet = null


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_physics_process(true)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_physics_process(false)
