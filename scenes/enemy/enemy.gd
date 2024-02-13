extends Area2D

@onready var turret = $Turret
@onready var timer = $Timer

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group(GameManager.SHIP_GROUP)
	
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)

func on_ship_destroyed():
	set_process(false)
	timer.stop()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var angle_to_player = global_position.direction_to(player.position).angle()
	turret.rotation = angle_to_player - PI / 2
	
	position.y += GameManager.GRAVITY * delta
	


func _on_body_entered(body):
	if body.is_in_group(GameManager.SHIP_GROUP):
		SignalManager.on_ship_destroyed.emit()	
	if body.is_in_group(GameManager.ASTEROID_DESTROY_GROUP):
		queue_free()

func _on_timer_timeout():
	SignalManager.on_enemy_fire.emit(turret.global_position, player.position)
