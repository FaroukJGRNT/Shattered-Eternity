extends PlayerState

@export var cooldown := 0.18
var timer := 0.0

func _ready() -> void:
	is_state_blocking = true

func enter():
	timer = cooldown
	player.velocity.y = player.JUMP_VELOCITY * 60000
	AnimPlayer.play("jump")
	
func update(delta):
	timer -= delta
	if timer <= 0:
		transitioned.emit("airborne")
		
	player.velocity.x = player.AERIAL_SPEED * 1.2 * player.facing * -1
	# Change state descending
	if player.is_on_floor():
		transitioned.emit("idle")

	player.handle_vertical_movement(player.get_gravity().y * delta)
	player.move_and_slide()
	
func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
