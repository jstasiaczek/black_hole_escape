extends Node

const SCORE_PATH = "user://data.json"

var _score: int = 0
var _high_score: int = 0
var _distance: float = 0

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

func decrease_score(value = 0):
	_score -= value
	SignalManager.on_player_score.emit()


func increas_score(value = 0):
	_score += value
	SignalManager.on_player_score.emit()

func update_high_score():
	var value = _score + int(_distance)
	if value > _high_score:
		_high_score = value
		write()

func get_score():
	return _score

func get_distance():
	return _distance

func update_distance(dist: float):
	_distance = dist
	
func get_high_score():
	return _high_score

func reset_score():
	_score = 0
