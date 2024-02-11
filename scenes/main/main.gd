extends Control
@onready var high_socre = $MarginContainer/high_socre

func _ready():
	high_socre.text = "High Score\n"+str(ScoreManager.get_high_score())+" points"

func _process(_delta):
	if Input.is_action_just_pressed("action"):
		GameManager.load_game_scene()
