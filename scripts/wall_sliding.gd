extends PlayerState

var old_direction = 0

func _ready() -> void:
	is_state_blocking = true

func enter():
	player.friction = 15
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
	player.handle_vertical_movement(player.get_gravity().y * delta)
	if player.is_on_floor():
		transitioned.emit("idle")

func exit():
	player.friction = 0

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
