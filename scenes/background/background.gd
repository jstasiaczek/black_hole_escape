extends ParallaxBackground

func _ready():
	SignalManager.on_ship_destroyed.connect(on_ship_destroyed)

func on_ship_destroyed():
	set_process(false)

func _process(delta):
	scroll_offset.y += GameManager.GRAVITY * delta
