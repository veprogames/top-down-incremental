extends Control

const TEXTURE_SIZE: Vector2i = Vector2.ONE * 48
const PADDING: int = 6

var TextureHeart: Texture2D = preload("res://player/ui/heart.png")
var TextureHeartEmpty: Texture2D = preload("res://player/ui/heart_empty.png")

@export var player: Player


func _ready() -> void:
	player.took_damage.connect(_on_player_took_damage)
	
	custom_minimum_size = Vector2(10 * (TEXTURE_SIZE.x + PADDING), TEXTURE_SIZE.y)


func _draw() -> void:
	var hp: int = player.hp
	for i: int in 10:
		var x: int = i * (TEXTURE_SIZE.x + PADDING)
		var texture: Texture2D = TextureHeart if hp >= i + 1 else TextureHeartEmpty
		draw_texture_rect(texture, Rect2(Vector2.RIGHT * x, TEXTURE_SIZE), false)


func _on_player_took_damage() -> void:
	queue_redraw()
