extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var explosion_animation = $ExplosionAnimation
@onready var shot_sound = $shotSound
@onready var boom_sound = $boomSound

var player_point: Vector2
var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = (player_point - position).normalized()
	rotation = position.direction_to(player_point).angle() + PI / 2
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	move_laser(0.15)
	shot_sound.play()

func move_laser(delta):
	position = position + (GameManager.LASER_SPEED * delta) * direction
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_point == null:
		return

	if sprite_2d.visible:
		move_laser(delta)
	position.y += GameManager.GRAVITY * delta

func on_ship_destroyed():
	set_process(false)


func _on_screen_exited():
	queue_free()

func die():
	boom_sound.play()
	sprite_2d.visible = false
	explosion_animation.visible = true
	explosion_animation.play("default")

func _on_area_entered(area):
	if area.is_in_group(GameManager.ASTEROID_GROUP):
		die()


func _on_body_entered(body):
	if body.is_in_group(GameManager.SHIP_GROUP):
		SignalManager.on_ship_destroyed.emit()
		die()


func _on_explosion_animation_animation_finished():
	queue_free()
