extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.visible = false

func _on_body_entered(body):
	if body.is_in_group(GameManager.SHIP_GROUP):
		animated_sprite_2d.visible = true


func _on_body_exited(body):
	if body.is_in_group(GameManager.SHIP_GROUP):
		animated_sprite_2d.visible = false
