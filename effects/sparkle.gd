class_name Sparkle
extends AnimatedSprite2D

static var SparkleScene: PackedScene = preload("res://effects/sparkle.tscn")


func _on_animation_finished() -> void:
	queue_free()


static func create(pos: Vector2) -> Sparkle:
	var sparkle: Sparkle = SparkleScene.instantiate() as Sparkle
	sparkle.global_position = pos
	return sparkle
