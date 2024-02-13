extends Node2D

var asteroidScene: PackedScene = preload("res://scenes/asteroids/asteroid.tscn")
var beaconScene: PackedScene = preload("res://scenes/beacon/beacon.tscn")
var enemyScene: PackedScene = preload("res://scenes/enemy/enemy.tscn")
const laser: PackedScene = preload("res://scenes/laser/laser.tscn")

@onready var laster_container = $laster_container
@onready var asteroid_container = $asteroid_container
@onready var spawn_min = $spawnMin
@onready var spawn_max = $spawnMax
@onready var timer = $Timer
@onready var game_over_timer = $gameOverTimer

var width: int 
var beacon_spawned: bool = false
var enemy_spawn_countdown: int = 0

func _ready():
	ScoreManager.reset_score()
	var x_min = spawn_min.position.x
	var x_max = spawn_max.position.x
	width = x_max - x_min
	
	spawn_asteroid_selector()
	spawn_asteroid_selector(250)
	
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	SignalManager.on_enemy_fire.connect(on_enemy_fire)
	
func on_ship_destroyed():
	set_physics_process(false)
	set_process(false)
	game_over_timer.start()
	timer.stop()

func getAsteroidRadius(asteroid: Node2D) -> float:
	if asteroid.height > asteroid.width:
		return asteroid.height / 2.0
	return asteroid.width / 2.0

func getAsteroidOrBeacon():
	var asteroid: Node2D
	var radius: float
	if randi_range(0, 100) > 90 and beacon_spawned == false:
		beacon_spawned = true
		asteroid = beaconScene.instantiate()
		radius = GameManager.BEACON_WIDTH / 2.0
	elif randi_range(0, 100) > 90 and enemy_spawn_countdown == 0:
		enemy_spawn_countdown = 5
		asteroid = enemyScene.instantiate()
		radius = GameManager.BEACON_WIDTH / 2.0
	else:
		asteroid =asteroidScene.instantiate()
		radius = getAsteroidRadius(asteroid)
	
	return [asteroid, radius]

func spawn_friend_asteroid(radius: float, asteroid: Node2D):
	if radius < 30 and randi_range(0, 100) > 80:
		return
	var clone = asteroid.duplicate()
	clone.position.y -= 50
	asteroid_container.add_child(clone)

func spawn_asteroid_selector(offset: int = 0):
	if GameManager.SPAWNER_TYPE == 1:
		spawn_asteroids(offset)
	elif GameManager.SPAWNER_TYPE == 2:
		spawn_asteroids2(offset)
	

func spawn_asteroids2(offset: int = 0):
	var last_free: float = -100
	beacon_spawned = false
	var is_space_left: bool = true
	var i: int = 0
	while is_space_left:
		var result = getAsteroidOrBeacon()
		var asteroid: Node2D = result[0]
		var radius: float = result[1]
		asteroid.position = Vector2(
			last_free + radius + randf_range(50, 80.0),
			-150+ offset + randf_range(-50.0, 50.0)
			)
		last_free = asteroid.position.x + radius
		asteroid_container.add_child(asteroid)
		if (asteroid.position.x + radius) >= width:
			is_space_left = false
		i += 1

func spawn_asteroids(offset: int = 0):
	var count: int = randi_range(GameManager.ASTEROID_COUNT_MIN, GameManager.ASTEROID_COUNT_MAX+1)
	var prev_pos: float = 0
	var prev_radius: float = 0
	beacon_spawned = false
	if enemy_spawn_countdown > 0:
		enemy_spawn_countdown -= 1
	for i in range(count):
		var result = getAsteroidOrBeacon()
		var asteroid: Node2D = result[0]
		var radius: float = result[1]
		asteroid.position = Vector2(
			(width / count) * i + randf_range(0, (width / count)),
			-150+ offset + randf_range(-50.0, 50.0)
			)
		if  asteroid.position.x - radius > prev_pos+prev_radius or i == 0:
			asteroid_container.add_child(asteroid)
			prev_pos = asteroid.position.x 
			prev_radius = radius

func on_enemy_fire(start_position: Vector2, end_position: Vector2):
	var laserIns = laser.instantiate()
	laserIns.player_point = end_position
	laserIns.position = start_position
	laster_container.add_child(laserIns)

func _on_timer_timeout():
	spawn_asteroid_selector()

func _on_game_over_timer_timeout():
	GameManager.load_game_over_scene()

