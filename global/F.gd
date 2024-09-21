class_name F
extends Object


static func t(seconds: float) -> String:
	var minutes: int = int(seconds / 60)
	var secs: int = int(seconds) % 60
	
	return "%02d:%02d" % [minutes, secs]
