extends Node

const ASTEROID_DESTROY_GROUP: String = "asteroid_destroy";
const SHIP_GROUP: String = "ship"
const ASTEROID_GROUP: String = "asteroid"
const ENEMY_GROUP: String = "enemy"
const SHIELD_GROUP: String = "shield"
const SHIP_BASE_MAIN_SPEED: float = 180
const SHIP_BASE_SECONDARY_SPEED: float = 80
const ASTEROID_COUNT_MIN: int = 4
const ASTEROID_COUNT_MAX: int = 7
const ASTEROID_TYPE_COUNT: int = 8
const BEACON_SCORE_VALUE: int = 1
const BEACON_WIDTH = 114
const GRAVITY: float = 80
const LASER_SPEED: int = 240
const SHIELD_COST: int = 3

const SPAWNER_TYPE: int = 1

var mainScene = preload("res://scenes/main/main.tscn")
var gameScene = preload("res://scenes/game/game.tscn")
var gameOverScene = preload("res://scenes/game_over/game_over.tscn")

func load_main_scene():
	get_tree().change_scene_to_packed(mainScene)

func load_game_scene():
	get_tree().change_scene_to_packed(gameScene)

func load_game_over_scene():
	get_tree().change_scene_to_packed(gameOverScene)
