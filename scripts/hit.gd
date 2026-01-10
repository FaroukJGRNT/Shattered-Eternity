extends PlayerState

@export var UP_VELOC = -250
@export var SIDE_VELOC = 250
@export var timeout = 2.0 

var timer = 0.0
var hit_direction := -1

func _ready() -> void:
	is_state_blocking = true

func enter():
	timer = timeout
	player.velocity.y = UP_VELOC
	player.direction = hit_direction * -1
	player.direct_sprite()
	player.move_and_slide()
	AnimPlayer.play("hit")
 
func update(delta):
	timer -= delta
	if timer <= 0:
		transitioned.emit("airborne")
	player.velocity.x = hit_direction * SIDE_VELOC
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
