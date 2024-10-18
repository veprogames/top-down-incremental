class_name PlayerDamageDisplay
extends VBoxContainer

@export var player_damage: PlayerDamage

@onready var grid_container_damages: GridContainer = $CenterContainer/GridContainerDamages
@onready var total_damage_label: TotalDamageLabel = $TotalDamageLabel


func _ready() -> void:
	total_damage_label.damage = player_damage.get_damage()
	player_damage.damage_part_changed.connect(_on_player_damage_damage_part_changed)


func update(key: String, value: float) -> void:
	var color: Color = Color.from_string(key, Color.WHITE)
	total_damage_label.set_damage_with_color(player_damage.get_damage(), color)
	
	var label: DamageMultiplierLabel
	if not grid_container_damages.has_node(key):
		label = DamageMultiplierLabel.create(color)
		label.name = key
		grid_container_damages.add_child(label)
	else:
		label = grid_container_damages.get_node(key) as DamageMultiplierLabel
	label.multiplier = value


func _on_player_damage_damage_part_changed(key: String, value: float) -> void:
	update(key, value)
