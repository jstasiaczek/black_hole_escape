extends Area2D

@onready var sprite_2d = $Sprite2D

@export var height = 0
@export var width = 0
var image: Texture2D
var rotation_speed: float = 0
#@onready var collision_shape_2d = $CollisionShape2D

func _init():
	image = load("res://assets/meteors/asteroid_"+str(randi_range(1, 8))+".png")
	width = image.get_width()
	height = image.get_height()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = image
	init_rotation()
	
	createCollisionShape(image)
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)
	
func init_rotation():
	var random_value = randi_range(0, 100)
	if random_value > 50:
		rotation_speed = 0.005 * random_value
	rotate(randf_range(0, 2*PI))

func on_ship_destroyed():
	set_process(false)

func createCollisionShape(image: Texture):
	var map = BitMap.new()
	map.create_from_image_alpha(image.get_image())
	var polygons = map.opaque_to_polygons(Rect2(Vector2(), map.get_size()))
	for poly in polygons:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygon.position -= map.get_size() / 2.0
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

