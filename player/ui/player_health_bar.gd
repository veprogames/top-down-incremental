extends Control

const TEXTURE_SIZE: Vector2i = Vector2.ONE * 48
const PADDING: int = 6
const HEARTS_PER_ROW: int = 10

var TextureHeart: Texture2D = preload("res://player/ui/heart.png")
var TextureHeartEmpty: Texture2D = preload("res://player/ui/heart_empty.png")

@export var player: Player


func _ready() -> void:
	player.took_damage.connect(_on_player_took_damage)
	
	@warning_ignore("integer_division") # desired
	var rows: int = player.max_hp / HEARTS_PER_ROW
	var cols: int = mini(10, player.max_hp)
	custom_minimum_size = Vector2(cols * (TEXTURE_SIZE.x + PADDING), rows * TEXTURE_SIZE.y)


func _draw() -> void:
	var hp: int = player.hp
	for i: int in player.max_hp:
		var x: int = (i % HEARTS_PER_ROW) * (TEXTURE_SIZE.x + PADDING)
		@warning_ignore("integer_division") # desired
		var y: int = (i / HEARTS_PER_ROW) * (TEXTURE_SIZE.x + PADDING)
		var texture: Texture2D = TextureHeart if hp >= i + 1 else TextureHeartEmpty
		draw_texture_rect(texture, Rect2(Vector2(x, y), TEXTURE_SIZE), false)


func _on_player_took_damage() -> void:
	queue_redraw()
