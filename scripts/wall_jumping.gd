extends PlayerState

@export var cooldown := 0.1
@export var UP_VELOC := -570
@export var HORIZ_VELOC := 320
@export var up_decel := 60
var up_veloc := UP_VELOC
var timer := 0.0

func _ready() -> void:
	is_state_blocking = true

func enter():
	up_veloc = UP_VELOC
	timer = cooldown
	AnimPlayer.play("jump")
	
func update(delta):
	timer -= delta
	if timer <= 0:
		transitioned.emit("airborne")
		
	player.velocity.x = HORIZ_VELOC * player.facing
	up_veloc += up_decel * 50 * delta
	player.velocity.y = up_veloc
	# Change state descending
	if player.is_on_floor():
		transitioned.emit("idle")

	player.move_and_slide()
	
func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
