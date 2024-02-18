extends Control

@onready var label = $MarginContainer/Label
@onready var game_over = $MarginContainer/game_over
@onready var distance_label = $MarginContainer/distanceLabel

var distance: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_player_score.connect(on_player_score)
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	
func on_ship_destroyed():
	game_over.visible = true
	ScoreManager.update_high_score()
	set_process(false)
	
func _process(delta):
	distance += (GameManager.GRAVITY * delta) / 1000
	var distFormated = "%10.1f" % distance
	if distance != ScoreManager.get_distance():
		distance_label.text = "DISTANCE "+ distFormated + "km"
		ScoreManager.update_distance(distance)
	

func on_player_score():
	var value = ScoreManager.get_score()
	label.text = str(value)+" points"
