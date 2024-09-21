class_name HighscoreList
extends Resource

@export var entries: Array[HighscoreEntry]


func _sort_function(a: HighscoreEntry, b: HighscoreEntry) -> int:
	return a.time > b.time


func add_entry(entry: HighscoreEntry) -> void:
	entries.append(entry)
	
	entries.sort_custom(_sort_function)
	
	entries.pop_back()
