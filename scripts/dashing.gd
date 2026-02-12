extends EvadeState

var slide_direction
var slide_start

func _ready() -> void:
	is_state_blocking = true

func enter():
	slide_direction = player.facing
	slide_start = player.position.x
	AnimPlayer.play("slide")

func update(delta):
	if player.is_on_wall() and not player.is_on_floor():
		transitioned.emit("airborne")
	if abs(player.position.x - slide_start) < player.SLIDE_DIST:
		player.velocity.x = slide_direction * player.SLIDE_SPEED * player.global_speed_scale
	else:
		if player.is_on_floor() and player.resonance_value >= 100:
			transitioned.emit("running")
			return
		player.velocity.x = slide_direction * player.SLIDE_SPEED * player.global_speed_scale / 5
		if not player.is_on_floor() and AnimPlayer.frame > 1:
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
