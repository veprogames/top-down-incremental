class_name UIHighscoreList
extends VBoxContainer

static var EntryScene: PackedScene = preload("res://highscore/ui_highscore_entry.tscn")


@export var list: HighscoreList : set = _set_list


func add_entry(entry: HighscoreEntry) -> UIHighscoreEntry:
	var ui_entry: UIHighscoreEntry = EntryScene.instantiate() as UIHighscoreEntry
	ui_entry.entry = entry
	add_child(ui_entry)
	return ui_entry


func _set_list(list_: HighscoreList) -> void:
	if list:
		list.entry_added.disconnect(_on_list_entry_added)
	
	list = list_
	
	for entry: HighscoreEntry in list.entries:
		add_entry(entry)
	
	list.entry_added.connect(_on_list_entry_added)


func _on_list_entry_added(index: int, entry: HighscoreEntry) -> void:
	var added_entry: UIHighscoreEntry = add_entry(entry)
	move_child(added_entry, index)
