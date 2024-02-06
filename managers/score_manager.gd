extends Node

var _score: int = 0
var _high_score: int = 0

func increas_score(value = 0):
	_score += value
	if _score > _high_score:
		_high_score = _score
	SignalManager.on_player_score.emit()

func get_score():
	return _score
	
func get_high_score():
	return _high_score

func reset_score():
	_score = 0
