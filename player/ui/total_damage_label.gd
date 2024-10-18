class_name TotalDamageLabel
extends HBoxContainer

@onready var label_total_damage: Label = $LabelTotalDamage

var label_color: Color = Color.WHITE
var label_scale: float = 1.0

var pulse_strength: float = 0.0

var t: float = 0.0

var damage: float = 1.0:
	set(dmg):
		damage = dmg
		pulse_strength = get_pulse_strength()
		if not is_node_ready():
			await ready
		label_total_damage.text = F.nl(dmg)


func set_damage_with_color(dmg: float, color: Color) -> void:
	damage = dmg
	label_color = label_color.lerp(color, 0.2)
	label_scale += 0.02


func get_pulse_strength() -> float:
	return clampf(
		remap(log(damage) / log(10), 3, 9, 0, 0.06),
		0,
		0.06
	)


func _process(delta: float) -> void:
	t += delta
	label_color = label_color.lerp(Color.WHITE, 4 * delta)
	label_scale = lerpf(label_scale, 1.0, 6 * delta)
	pivot_offset = size / 2
	scale = Vector2.ONE * label_scale * (1 + sin(18 * t) * pulse_strength)
	rotation = sin(4.5 * t) * pulse_strength
	label_total_damage.add_theme_color_override(&"font_color", label_color)
