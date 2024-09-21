class_name UIHighscoreEntry
extends HBoxContainer

@export var entry: HighscoreEntry : set = _set_highscore_entry

@onready var label_name: Label = $LabelName
@onready var label_time: Label = $LabelTime


func _set_highscore_entry(entry_: HighscoreEntry) -> void:
	if not is_node_ready():
		await ready
	
	if entry:
		entry.removed.disconnect(_on_entry_removed)
	
	entry = entry_
	entry.removed.connect(_on_entry_removed)
	
	label_name.text = entry_.player_name
	label_time.text = F.t(entry_.time)


func _on_entry_removed() -> void:
	queue_free()
