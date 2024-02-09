extends Control

func _process(_delta):
	if Input.is_action_just_pressed("action"):
		GameManager.load_game_scene()
