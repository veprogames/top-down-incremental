class_name HighscoreEntry
extends Resource

@warning_ignore("unused_signal") # used in UIHighscoreEntry
signal removed

@export var player_name: String
@export var time: float


static func create(player_name_: String, time_: float) -> HighscoreEntry:
	var entry: HighscoreEntry = HighscoreEntry.new()
	entry.player_name = player_name_
	entry.time = time_
	return entry
