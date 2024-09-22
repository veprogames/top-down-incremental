class_name F
extends Object

static var suffixes: Array[String] = ["", "K", "M", "B", "T", "q", "Q", "s", "S", "O", "N", "D"]


## format a time value in mm:ss
static func t(seconds: float) -> String:
	var minutes: int = int(seconds / 60)
	var secs: int = int(seconds) % 60
	
	return "%02d:%02d" % [minutes, secs]


## Format the number in short form with suffixes
static func n(num: float) -> String:
	var suffix_index: int = int(log(num) / log(10) / 3.0)
	suffix_index = mini(suffixes.size() - 1, suffix_index)
	var mantissa: float = num / 10.0 ** (3 * suffix_index)
	return F.nl(mantissa) + suffixes[suffix_index]


## Format the number in long form without suffixes
static func nl(num: float) -> String:
	if num == 0:
		return "0"
	if num < 0:
		return "-%s" % F.n(-num)
	if num < 1_000:
		return "%d" % num
	
	var result: String = ""
	while num > 1000:
		result = "%03d %s" % [fmod(num, 1000.0), result]
		num /= 1000
	result = "%d %s" % [num, result]
	return result
