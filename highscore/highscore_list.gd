class_name HighscoreList
extends Resource

signal entry_added(index: int, entry: HighscoreEntry)


@export var entries: Array[HighscoreEntry]


func _sort_function(a: HighscoreEntry, b: HighscoreEntry) -> int:
	return a.time > b.time


func add_entry(entry: HighscoreEntry) -> void:
	entries.append(entry)
	
	entries.sort_custom(_sort_function)
	
	@warning_ignore("unsafe_cast") # entries typed as Array[HighscoreEntry]
	var removed: HighscoreEntry = entries.pop_back() as HighscoreEntry
	removed.removed.emit()
	
	entry_added.emit(entries.find(entry), entry)
