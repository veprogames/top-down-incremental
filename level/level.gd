class_name Level
extends Node2D

var time: float = 0.0

@onready var enemies: Node2D = $Enemies
@onready var gems: Node2D = $Gems

@onready var label_fps: Label = $CanvasLayer/LabelFPS


func _process(delta: float) -> void:
	time += delta
	
	label_fps.text = "%d fps" % Engine.get_frames_per_second()


func add_enemy(enemy: Enemy) -> void:
	enemies.add_child(enemy)
	if enemies.get_child_count() > 1024:
		enemies.get_child(0).queue_free()


func add_gem(gem: Gem) -> void:
	gems.add_child(gem)
	if gems.get_child_count() > 4096:
		gems.get_child(0).queue_free()
