class_name Level
extends Node2D

var time: float = 600.0


func _process(delta: float) -> void:
	time += delta
