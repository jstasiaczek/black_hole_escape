extends Control

@onready var points = $MarginContainer/points
@onready var high_points = $MarginContainer/high_points

func _ready():
	var dist = "%.1f" % ScoreManager.get_distance()
	points.text = str(ScoreManager.get_score())+" points\n" + "Distance " + dist + "km"
	high_points.text = "High Score\n"+str(ScoreManager.get_high_score())+" points"

func _process(_delta):
	if Input.is_action_just_pressed("action"):
		GameManager.load_game_scene()
