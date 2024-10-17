class_name Level
extends Node2D

var time: float = 0.0

var game_over: bool = false

@onready var enemies: Node2D = $Enemies
@onready var gems: Node2D = $Gems

@onready var game_over_screen: GameOverScreen = $CanvasLayerGameOver/GameOverScreen
@onready var canvas_layer_dialogs: CanvasLayer = $CanvasLayerDialogs
@onready var audio_stream_player_game_over: AudioStreamPlayer = $AudioStreamPlayerGameOver


func _ready() -> void:
	game_over_screen.initialize()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if not game_over:
		time += delta
		
		if Input.is_action_just_pressed(&"game_back"):
			var pause_menu: PauseMenu = PauseMenu.create()
			canvas_layer_dialogs.add_child(pause_menu)
			pause_menu.options_pressed.connect(_on_pause_menu_options_pressed)
	
	cleanup()


func add_enemy(enemy: Enemy) -> void:
	enemies.add_child(enemy)


func add_gem(gem: Gem) -> void:
	gems.add_child(gem)


func cleanup() -> void:
	var enemies_: int = enemies.get_child_count()
	if enemies_ > 256:
		for i: int in enemies_ - 256:
			enemies.get_child(0).queue_free()
		
	var gems_: int = gems.get_child_count()
	if gems_ > 1024:
		@warning_ignore("integer_division") # desired
		for i: int in (gems_ - 1024) / 8 + 1:
			gems.get_child(i).queue_free()


func _on_player_died() -> void:
	game_over = true
	audio_stream_player_game_over.play()
	game_over_screen.fade_in()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Game.highscores.add_entry(HighscoreEntry.create(Game.player_name, time))
	Game.save_game()


func _on_game_over_screen_restarted() -> void:
	get_tree().reload_current_scene()


func _on_pause_menu_options_pressed(menu: OptionsMenu) -> void:
	canvas_layer_dialogs.add_child(menu)
