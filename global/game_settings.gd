class_name GameSettings
extends RefCounted

const CONFIG_PATH: String = "user://game.cfg"

const PHYSICS_LOW: int = 0
const PHYSICS_HIGH: int = 1

var config: ConfigFile = ConfigFile.new()

## 0 = low, 1 = high
var physics_mode: int : set = set_physics_mode

func _init() -> void:
	config.load(CONFIG_PATH)
	
	physics_mode = config.get_value("Game", "physics", PHYSICS_HIGH)


func save() -> void:
	config.save(CONFIG_PATH)


func apply() -> void:
	if physics_mode == PHYSICS_HIGH:
		Engine.physics_ticks_per_second = 240
	else:
		Engine.physics_ticks_per_second = 60


func set_physics_mode(mode: int) -> void:
	assert(mode == PHYSICS_LOW or mode == PHYSICS_HIGH)
	
	physics_mode = mode
	config.set_value("Game", "physics", mode)
