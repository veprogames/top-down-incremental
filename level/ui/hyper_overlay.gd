class_name HyperOverlay
extends ColorRect


var alpha: float = 0.0
var t: float = 0.0


func _process(delta: float) -> void:
	t += delta
	
	color = Color.from_hsv(t / 16, 1, 1, alpha)


func fade_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"alpha", 0.2, 15).set_ease(Tween.EASE_IN_OUT)


func is_faded_in() -> bool:
	return alpha > 0
