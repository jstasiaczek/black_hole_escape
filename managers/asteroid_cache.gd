extends Node
const ASTEROID_PATH: String = "res://assets/meteors/"


class AsteroidInfo:
	var path: String
	var image: Texture2D
	var polygons: Array[PackedVector2Array]
	var width: int
	var height: int

var _asteroids: Array[AsteroidInfo] = []

func _init():
	var asteroid_files: Array[String] = _get_list()
	_preload_asteroids(asteroid_files)
	
func get_random_asteroid() -> AsteroidInfo:
	var index: int = randi_range(0, _asteroids.size()-1)
	return _asteroids[index]
	
func _preload_asteroids(asteroid_files: Array[String]):
	for asteroid_file_name in asteroid_files:
		var image = load(ASTEROID_PATH + asteroid_file_name)
		var width = image.get_width()
		var height = image.get_height()
		var polygons = _create_collision_shape(image)
		
		_asteroids.append(_create_info(asteroid_file_name, width, height, image, polygons))

func _create_info(path: String, width: int, height: int, image: Texture2D, polygons: Array[PackedVector2Array]) -> AsteroidInfo:
	var info = AsteroidInfo.new()
	info.path = path
	info.height = height
	info.width = width
	info.image = image
	info.polygons = polygons
	return info
	
func _get_list() -> Array[String]:
	var list: Array[String] = []
	
	for i in range(1, GameManager.ASTEROID_TYPE_COUNT+1):
		list.append("asteroid_" + str(i) + ".png")
	return list

func _create_collision_shape(image: Texture) -> Array[PackedVector2Array]:
	var map = BitMap.new()
	map.create_from_image_alpha(image.get_image())
	return map.opaque_to_polygons(Rect2(Vector2(), map.get_size()))
