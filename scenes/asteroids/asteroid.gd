extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var shadow_container = $shadowContainer

@export var height = 0
@export var width = 0
var image: Texture2D
var rotation_speed: float = 0
var asteroid_info
#@onready var collision_shape_2d = $CollisionShape2D

func _init():
	asteroid_info = AsteroidCache.get_random_asteroid()
	image = asteroid_info.image
	width = asteroid_info.width
	height = asteroid_info.height

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = image
	init_rotation()
	create_collision_shape()
	create_light_shape()

	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	
func init_rotation():
	var random_value = randi_range(0, 100)
	if random_value > 50:
		rotation_speed = 0.005 * random_value
	rotate(randf_range(0, 2*PI))

func on_ship_destroyed():
	set_process(false)

func create_light_shape():
	for poly in asteroid_info.polygons:
		var shadow = LightOccluder2D.new()
		var shadow_polygon = OccluderPolygon2D.new()
		shadow_polygon.polygon = poly
		shadow.occluder = shadow_polygon
		shadow.position -= Vector2(width / 2.0, height/ 2.0)
		shadow_container.add_child(shadow)
	


func create_collision_shape():
	for poly in asteroid_info.polygons:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygon.position -= Vector2(width / 2.0, height/ 2.0)
		add_child(collision_polygon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += GameManager.GRAVITY * delta
	if rotation_speed > 0:
		rotation += rotation_speed * delta


func _on_body_entered(body):
	if body.is_in_group(GameManager.ASTEROID_DESTROY_GROUP):
		queue_free()
	elif body.is_in_group(GameManager.SHIP_GROUP):
		SignalManager.on_ship_destroyed.emit()

