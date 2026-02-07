extends PlayerState

var old_direction = 0
@export var max_friction := 60.0
@export var min_friction := 15.0
@export var increment :=  0.6
var friction = 100

func _ready() -> void:
	is_state_blocking = true

func enter():
	friction = min_friction
	player.aerial_dash_used = false
	player.aerial_attack_used = false
	player.friction = friction
	old_direction = player.direction
	player.velocity.x =  0
	AnimPlayer.play("wallsliding")

func update(delta):
	print(friction)
	friction = min(friction + (increment * delta), max_friction)
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
	player.friction = friction
	player.move_and_slide()

func exit():
	player.friction = 0

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
