extends ParallaxLayer

@export var CLOUD_SPEED = -15

func _process(delta) -> void:
	motion_offset.x += CLOUD_SPEED * delta
