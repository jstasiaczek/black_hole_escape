extends Control

@onready var points = $MarginContainer/points
@onready var high_points = $MarginContainer/high_points

func _ready():
	points.text = str(ScoreManager.get_score())+" points"
	high_points.text = "High Score\n"+str(ScoreManager.get_score())+" points"

func _process(delta):
	if Input.is_action_just_pressed("action"):
		GameManager.load_game_scene()
