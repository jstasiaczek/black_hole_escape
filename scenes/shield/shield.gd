extends Area2D
@onready var shield_up = $ShieldUp
@onready var no_points = $NoPoints

var ship_destroyed: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_shield_hit.connect(on_shield_hit)
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)

func on_ship_destroyed():
	ship_destroyed = true
	visible = false

func on_shield_hit():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shield") and ship_destroyed == false:
		if ScoreManager.get_score() >= GameManager.SHIELD_COST and visible == false:
			visible = true
			ScoreManager.decrease_score(GameManager.SHIELD_COST)
			shield_up.play()
			SignalManager.on_shield_activated.emit()
		elif ScoreManager.get_score() < GameManager.SHIELD_COST and visible == false:
			no_points.play()
