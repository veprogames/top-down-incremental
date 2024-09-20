class_name LevelTime
extends Label

@onready var level: Level = get_tree().current_scene as Level


func _ready() -> void:
	assert(is_instance_valid(level))


func _process(_delta: float) -> void:
	var minutes: int = int(level.time / 60)
	var seconds: int = int(level.time) % 60
	
	text = "%02d:%02d" % [minutes, seconds]
