extends ProjectileTemplate

@export var acceleration := 7
@export var speed := 65
@export var max_speed := 270
@export var direction := 1

func move(delta):
	position.x += (speed * delta * direction)
	speed += acceleration * 50 * delta
