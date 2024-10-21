class_name OptionsMenu
extends Panel

static var Scene: PackedScene = preload("res://ui/options_menu.tscn")

@onready var h_slider_sensitivity: HSlider = $MarginContainer/VBoxContainer/HBoxContainer2/HSliderSensitivity
@onready var spin_box_max_fps: SpinBox = $MarginContainer/VBoxContainer/HBoxContainer3/SpinBoxMaxFps
@onready var h_slider_master_vol: HSlider = $MarginContainer/VBoxContainer/HBoxContainer4/HSliderMasterVol
@onready var h_slider_music_vol: HSlider = $MarginContainer/VBoxContainer/HBoxContainer5/HSliderMusicVol

func _ready() -> void:
	h_slider_sensitivity.value = Game.settings.sensitivity
	spin_box_max_fps.value = Game.settings.max_fps
	h_slider_master_vol.value = Game.settings.master_volume
	h_slider_music_vol.value = Game.settings.music_volume
	
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


func _on_spin_box_value_changed(value: float) -> void:
	var fps: int = value as int
	if fps > 0 and fps < 30:
		fps = 30
		spin_box_max_fps.value = 30
	Game.settings.max_fps = fps


func _on_h_slider_master_vol_value_changed(value: float) -> void:
	Game.settings.master_volume = value


func _on_h_slider_music_vol_value_changed(value: float) -> void:
	Game.settings.music_volume = value


func _on_button_vsync_off_pressed() -> void:
	Game.settings.vsync = Game.settings.VSYNC_OFF


func _on_button_vsync_on_pressed() -> void:
	Game.settings.vsync = Game.settings.VSYNC_ON
