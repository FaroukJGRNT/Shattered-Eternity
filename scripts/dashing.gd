extends PlayerState

var slide_direction
var slide_start

func enter():
	slide_direction = player.facing
	slide_start = player.position.x
	AnimPlayer.play("slide")

func update(delta):
	if player.is_on_wall() and not player.is_on_floor():
		transitioned.emit("wallsliding") 
	if abs(player.position.x - slide_start) < player.SLIDE_DIST:
		player.velocity.x = slide_direction * player.SLIDE_SPEED
	else:
		player.velocity.x = slide_direction * player.SLIDE_SPEED / 5
		if not player.is_on_floor():
			transitioned.emit("airborne")
			return
	player.velocity.y = 0
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		transitioned.emit("airborne")
	player.move_and_slide()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if AnimPlayer.animation == "slide":
		transitioned.emit("idle")
