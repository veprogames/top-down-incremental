class_name GameSettings
extends RefCounted

const CONFIG_PATH: String = "user://game.cfg"

const PHYSICS_LOW: int = 0
const PHYSICS_HIGH: int = 1

const VSYNC_OFF: int = 0
const VSYNC_ON: int = 1

var config: ConfigFile = ConfigFile.new()

## 0 = low, 1 = high
var physics_mode: int : set = set_physics_mode

var sensitivity: float = 0.5 : set = set_sensitivity

var max_fps: int = 0 : set = set_max_fps
var vsync: int = VSYNC_ON : set = set_vsync

var master_volume: float = 0.0 : set = set_master_volume
var music_volume: float = 0.0 : set = set_music_volume

func _init() -> void:
	config.load(CONFIG_PATH)
	
	physics_mode = config.get_value("Game", "physics", PHYSICS_HIGH)
	sensitivity = config.get_value("Game", "sensitivity", 0.5)
	max_fps = config.get_value("Game", "max_fps", 0)
	vsync = config.get_value("Game", "vsync", VSYNC_ON)
	master_volume = config.get_value("Game", "master_volume", 0)
	music_volume = config.get_value("Game", "music_volume", 0)


func save() -> void:
	config.save(CONFIG_PATH)


func apply() -> void:
	if physics_mode == PHYSICS_HIGH:
		Engine.physics_ticks_per_second = 60
	else:
		Engine.physics_ticks_per_second = 30
	
	Engine.max_fps = max_fps
	
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync == VSYNC_ON else DisplayServer.VSYNC_DISABLED
	)
	
	AudioServer.set_bus_volume_db(0, master_volume)
	AudioServer.set_bus_volume_db(1, music_volume)
	
	AudioServer.set_bus_mute(0, master_volume <= -42)
	AudioServer.set_bus_mute(1, music_volume <= -42)


func set_physics_mode(mode: int) -> void:
	assert(mode == PHYSICS_LOW or mode == PHYSICS_HIGH)
	
	physics_mode = mode
	config.set_value("Game", "physics", mode)


func set_sensitivity(s: float) -> void:
	sensitivity = s
	config.set_value("Game", "sensitivity", s)


func set_max_fps(fps: int) -> void:
	if fps > 0:
		fps = maxi(fps, 30)
	max_fps = fps
	config.set_value("Game", "max_fps", fps)


func set_vsync(vsync_: bool) -> void:
	vsync = vsync_
	config.set_value("Game", "vsync", vsync_)


func set_master_volume(vol: float) -> void:
	master_volume = vol
	config.set_value("Game", "master_volume", vol)
	apply()


func set_music_volume(vol: float) -> void:
	music_volume = vol
	config.set_value("Game", "music_volume", vol)
	apply()
