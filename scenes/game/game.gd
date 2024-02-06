extends Node2D

var asteroidScene: PackedScene = preload("res://scenes/asteroids/asteroid.tscn")
var beaconScene: PackedScene = preload("res://scenes/beacon/beacon.tscn")

@onready var asteroid_container = $asteroid_container
@onready var spawn_min = $spawnMin
@onready var spawn_max = $spawnMax
@onready var timer = $Timer
@onready var game_over_timer = $gameOverTimer

var width: int 
var beacon_spawned: bool = false

func _ready():
	ScoreManager.reset_score()
	var x_min = spawn_min.position.x
	var x_max = spawn_max.position.x
	width = x_max - x_min
	
	spawn_asteroids()
	spawn_asteroids(300)
	
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	
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
	if randi_range(0, 100) > 80 and beacon_spawned == false:
		beacon_spawned = true
		asteroid = beaconScene.instantiate()
		radius = 114
	else:
		asteroid =asteroidScene.instantiate()
		radius = getAsteroidRadius(asteroid)
	
	return [asteroid, radius]

func spawn_asteroids(offset: int = 0):
	var count: int = randi_range(GameManager.ASTEROID_COUNT_MIN, GameManager.ASTEROID_COUNT_MAX+1)
	var prev_pos: float = 0
	var prev_radius: float = 0
	beacon_spawned = false
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

func _on_timer_timeout():
	spawn_asteroids()

func _on_game_over_timer_timeout():
	GameManager.load_game_over_scene()
