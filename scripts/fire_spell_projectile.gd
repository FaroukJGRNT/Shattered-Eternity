extends ProjectileTemplate

var facing := 1
@export var speed := 400.0
var direction := Vector2(1, 0)
var downwards := false

func move(delta):
	if facing == 1:
		if downwards:
			rotation_degrees = 45
		anim_player.flip_h = false
	else:
		if downwards:
			rotation_degrees = -45
		anim_player.flip_h = true
	position.x +=  direction.x * speed * delta * facing
	position.y += direction.y * speed * delta

func go_downwards():
	downwards = true
	direction = Vector2(1, 0.6)

func on_anim_finished():
	if anim_player.animation == "hit":
		queue_free()

func destroy():
	destroyed = true
	hitbox.desactivate()
	if hurtbox:
		hurtbox.desactivate()
	# Maybe play an animation
	anim_player.play("hit")
