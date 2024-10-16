class_name GameSettings
extends RefCounted

const CONFIG_PATH: String = "user://game.cfg"

const PHYSICS_LOW: int = 0
const PHYSICS_HIGH: int = 1

var config: ConfigFile = ConfigFile.new()

## 0 = low, 1 = high
var physics_mode: int : set = set_physics_mode

var sensitivity: float = 0.5 : set = set_sensitivity

var max_fps: int = 0 : set = set_max_fps

func _init() -> void:
	config.load(CONFIG_PATH)
	
	physics_mode = config.get_value("Game", "physics", PHYSICS_HIGH)
	sensitivity = config.get_value("Game", "sensitivity", 0.5)
	max_fps = config.get_value("Game", "max_fps", 0)


func save() -> void:
	config.save(CONFIG_PATH)


func apply() -> void:
	if physics_mode == PHYSICS_HIGH:
		Engine.physics_ticks_per_second = 60
	else:
		Engine.physics_ticks_per_second = 30
	
	Engine.max_fps = max_fps


func set_physics_mode(mode: int) -> void:
	assert(mode == PHYSICS_LOW or mode == PHYSICS_HIGH)
	
	physics_mode = mode
	config.set_value("Game", "physics", mode)


func set_sensitivity(s: float) -> void:
	sensitivity = s
	config.set_value("Game", "sensitivity", s)


func set_max_fps(fps: int) -> void:
	max_fps = fps
	config.set_value("Game", "max_fps", fps)
