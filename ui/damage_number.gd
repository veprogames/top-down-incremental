class_name DamageNumber
extends Label

static var DamageNumberScene: PackedScene = preload("res://ui/damage_number.tscn")

@export var damage: float


func _ready() -> void:
	text = F.n(damage)
	scale = Vector2.ZERO
	
	var number_size: float = get_number_size()
	
	add_theme_color_override(&"font_color", get_number_color())
	
	#position -= ((size + pivot_offset) * number_size) / 2
	position -= pivot_offset
	
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, ^"scale", Vector2.ONE * number_size, 0.5) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, 0.5) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_delay(0.25)
	await tween.finished
	queue_free()


func get_number_size() -> float:
	return minf(
		0.2 + 0.075 * log(damage) / log(10),
		1.0
	)


func get_number_color() -> Color:
	var intensity: float = 0.1 * log(damage) / log(10)
	return Color(1, 1 - intensity * 0.4, 1 - intensity)


static func create(dmg: float) -> DamageNumber:
	var num: DamageNumber = DamageNumber.DamageNumberScene.instantiate() as DamageNumber
	num.damage = dmg
	return num
