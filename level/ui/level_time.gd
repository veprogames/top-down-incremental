class_name LevelTime
extends Label

@onready var level: Level = get_tree().current_scene as Level


func _ready() -> void:
	assert(is_instance_valid(level))


func _process(_delta: float) -> void:
	text = F.t(level.time)
