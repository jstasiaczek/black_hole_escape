extends Control

@onready var label = $MarginContainer/Label
@onready var game_over = $MarginContainer/game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_player_score.connect(on_player_score)
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	
func on_ship_destroyed():
	game_over.visible = true

func on_player_score():
	var value = ScoreManager.get_score()
	label.text = str(value)+" points"
