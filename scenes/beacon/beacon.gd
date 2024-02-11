extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var point_light_2d = $PointLight2D

var already_scored: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.visible = false
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	init_rotation()

func init_rotation():
	var rotate_value = randf_range(0, 2*PI)
	rotate(rotate_value)
	animated_sprite_2d.rotate(-rotate_value)
	
func on_ship_destroyed():
	set_physics_process(false)
	set_process(false)

func _process(delta):
	position.y += GameManager.GRAVITY * delta

func _on_body_entered(body):
	if body.is_in_group(GameManager.ASTEROID_DESTROY_GROUP):
		queue_free()
	elif body.is_in_group(GameManager.SHIP_GROUP) and already_scored == false:
		already_scored = true
		on_body_entered_ship(body)

func on_body_entered_ship(_body):
	ScoreManager.increas_score(GameManager.BEACON_SCORE_VALUE)
	audio_stream_player.play()
	sprite_2d.visible = false
	point_light_2d.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play()


func _on_animated_sprite_2d_animation_finished():
	queue_free()
