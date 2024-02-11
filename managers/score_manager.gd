extends Node

const SCORE_PATH = "user://data.json"

var _score: int = 0
var _high_score: int = 0

func _ready():
	read()

func write():
	var file = FileAccess.open(SCORE_PATH, FileAccess.WRITE)
	file.store_string(str(_high_score))

func read():
	var file = FileAccess.open(SCORE_PATH, FileAccess.READ)
	if file == null:
		write()
	else:
		_high_score = int(file.get_as_text())
		print(_high_score)

func increas_score(value = 0):
	_score += value
	if _score > _high_score:
		_high_score = _score
		write()
	SignalManager.on_player_score.emit()

func get_score():
	return _score
	
func get_high_score():
	return _high_score

func reset_score():
	_score = 0
