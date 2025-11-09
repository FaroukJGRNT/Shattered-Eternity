extends PlayerState

func _ready() -> void:
	is_state_blocking = true

func enter():
	player.velocity.y = -250
	player.direction = player.hit_direction * -1
	player.direct_sprite()
	player.move_and_slide()
	AnimPlayer.play("hit")
 
func update(delta):
	player.velocity.x = player.hit_direction * 250
	if player.is_on_floor():
		transitioned.emit("idle")
	player.handle_vertical_movement(player.get_gravity().y * delta)

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
