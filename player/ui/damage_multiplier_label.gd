class_name DamageMultiplierLabel
extends Label

static var Scene: PackedScene = preload("res://player/ui/damage_multiplier_label.tscn")

var color: Color = Color.WHITE:
	set(col):
		color = col
		if not is_node_ready():
			await ready
		if col.get_luminance() < 0.15:
			add_theme_color_override(&"font_outline_color", Color.WHITE)
			add_theme_color_override(&"font_shadow_color", Color(1, 1, 1, 0.25))

var multiplier: float = 1.0:
	set(multi):
		multiplier = multi
		text = "x%.2f" % multi
		pivot_offset = size / 2
		target_scale += 0.04

var target_scale: float = 1.0


func _process(delta: float) -> void:
	target_scale = lerpf(target_scale, 1.0, 12 * delta)
	add_theme_color_override(&"font_color", color + 6 * Color.WHITE * (target_scale - 1.0))
	scale = Vector2.ONE * target_scale


static func create(color_: Color) -> DamageMultiplierLabel:
	var label: DamageMultiplierLabel = Scene.instantiate() as DamageMultiplierLabel
	label.color = color_
	return label
