class_name PlayerDamageDisplay
extends Control

@export var player_damage: PlayerDamage

@onready var label_total_damage: Label = $HBoxContainer/LabelTotalDamage
@onready var h_box_damages: HBoxContainer = $HBoxContainer/HBoxDamages


func _ready() -> void:
	update()
	
	player_damage.damage_part_changed.connect(_on_player_damage_damage_part_changed)


func update() -> void:
	label_total_damage.text = "%.0f" % player_damage.get_damage()
	
	for key: String in player_damage._map:
		var label: Label
		if not h_box_damages.has_node(key):
			label = Label.new()
			label.name = key
			label.modulate = Color.from_string(key, Color.WHITE)
			h_box_damages.add_child(label)
		else:
			label = h_box_damages.get_node(key) as Label
		label.text = "x%.2f" % player_damage._map[key]


func _on_player_damage_damage_part_changed(_key: String, _value: float) -> void:
	update()
