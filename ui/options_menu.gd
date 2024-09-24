class_name OptionsMenu
extends Panel

static var Scene: PackedScene = preload("res://ui/options_menu.tscn")

@onready var h_slider_sensitivity: HSlider = $MarginContainer/VBoxContainer/HBoxContainer2/HSliderSensitivity

func _ready() -> void:
	h_slider_sensitivity.value = Game.settings.sensitivity
	
	scale = Vector2.ZERO
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_ELASTIC)


func _on_button_physics_low_pressed() -> void:
	Game.settings.physics_mode = Game.settings.PHYSICS_LOW


func _on_button_physics_high_pressed() -> void:
	Game.settings.physics_mode = Game.settings.PHYSICS_HIGH


func _on_button_close_pressed() -> void:
	Game.settings.apply()
	Game.settings.save()
	
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2.ZERO, 0.25) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	queue_free()


static func create() -> OptionsMenu:
	return Scene.instantiate() as OptionsMenu


func _on_h_slider_sensitivity_value_changed(value: float) -> void:
	Game.settings.sensitivity = value
