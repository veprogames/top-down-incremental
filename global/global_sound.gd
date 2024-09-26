extends Node


func play(stream: AudioStream, pitch: float = 1.0) -> void:
	var node: AudioStreamPlayer = AudioStreamPlayer.new()
	node.stream = stream
	node.pitch_scale = pitch
	add_child(node)
	node.play()
	await node.finished
	node.queue_free()
