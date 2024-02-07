extends CharacterBody2D

@onready var image = $Image
@onready var thruster_forward = $thrusterForward
@onready var thruster_backward = $thrusterBackward
@onready var thruster_right = $thrusterRight
@onready var thruster_left = $thrusterLeft
@onready var destroy = $destroy
@onready var thruster_audio = $ThrusterAudio
@onready var boom_player = $BoomPlayer

var died: bool = false
var button_pressed_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_thrusters()
	destroy.visible = false
	thruster_audio.play()
	
	SignalManager.on_ship_destroyed.connect(die)

func reset_thrusters():
	thruster_forward.visible = false
	thruster_backward.visible = false
	thruster_left.visible = false
	thruster_right.visible = false
	thruster_audio.stop()

func _physics_process(delta):
	if died:
		return
	velocity.y += GameManager.GRAVITY * delta
	fly_in_direction("forward", "y", -GameManager.SHIP_BASE_MAIN_SPEED, thruster_forward, delta)
	fly_in_direction("backward", "y", GameManager.SHIP_BASE_SECONDARY_SPEED, thruster_backward, delta)
	fly_in_direction("left", "x", -GameManager.SHIP_BASE_SECONDARY_SPEED, thruster_right, delta)
	fly_in_direction("right", "x", GameManager.SHIP_BASE_SECONDARY_SPEED, thruster_left, delta)
	
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		SignalManager.on_ship_destroyed.emit()
	
	move_and_slide()

func play_music_for_action(action: String):
	if Input.is_action_just_pressed(action):
		if button_pressed_count == 0:
			thruster_audio.volume_db = -10
		button_pressed_count += 1
	if Input.is_action_just_released(action):
		button_pressed_count -= 1
		if button_pressed_count == 0:
			thruster_audio.volume_db = -15

func fly_in_direction(action: String, axis: String, modifier: float, animation: AnimatedSprite2D, delta):
	play_music_for_action(action)

	if Input.is_action_pressed(action):
		velocity[axis] += modifier * delta
		animation.visible = true
	else:
		animation.visible = false

func die():
	boom_player.play()
	destroy.visible = true
	image.visible = false
	died = true
	set_physics_process(false)
	reset_thrusters()
	thruster_audio.stop()
	destroy.play("default")
