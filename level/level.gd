class_name Level
extends Node2D

var time: float = 0.0

var game_over: bool = false

@onready var enemies: Node2D = $Enemies
@onready var gems: Node2D = $Gems

@onready var label_fps: Label = $CanvasLayer/LabelFPS
@onready var game_over_screen: GameOverScreen = $CanvasLayerGameOver/GameOverScreen
@onready var canvas_layer_pause: CanvasLayer = $CanvasLayerPause


func _ready() -> void:
	Game.load_game()
	game_over_screen.initialize()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if not game_over:
		time += delta
		
		if Input.is_action_just_pressed(&"game_back"):
			canvas_layer_pause.add_child(PauseMenu.create())
	
	label_fps.text = "%d fps" % Engine.get_frames_per_second()
	
	cleanup()


func add_enemy(enemy: Enemy) -> void:
	enemies.add_child(enemy)


func add_gem(gem: Gem) -> void:
	gems.add_child(gem)


func _on_player_died() -> void:
	game_over = true
	game_over_screen.fade_in()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Game.highscores.add_entry(HighscoreEntry.create("Player", time))
	Game.save_game()


func _on_game_over_screen_restarted() -> void:
	get_tree().reload_current_scene()


func cleanup() -> void:
	if enemies.get_child_count() > 256:
		enemies.get_child(0).queue_free()
	if gems.get_child_count() > 1024:
		for i: int in 16:
			gems.get_child(i).queue_free()
