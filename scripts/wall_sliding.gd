extends PlayerState

var frames = 0
var old_direction = 0

func enter():
	old_direction = player.direction
	player.velocity.x =  0
	AnimPlayer.play("wallsliding")

func update(delta):
	if old_direction == 1:
		AnimPlayer.flip_h = true
	if old_direction == -1:
		AnimPlayer.flip_h = false
	if Input.is_action_just_pressed("jump"):
		transitioned.emit("walljumping")
		return
	player.handle_vertical_movement(delta)
	if player.is_on_floor():
		transitioned.emit("idle")
	if not player.is_on_wall():
		frames += 1
		if frames > 30:
			transitioned.emit("airborne")
	else:
		frames = 0

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
