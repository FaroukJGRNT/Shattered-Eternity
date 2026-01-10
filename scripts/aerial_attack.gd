extends AttackState
class_name AerialAttack

@export var horizontal_friction := 0.0
@export var vertital_friction := 0.0

# If the player lands before reaching this frame, he will continue with the groud attack instead
@export var frame_teshold := -1
@export var ground_attck := ""

func enter():
	super.enter()
	player.friction = vertital_friction

func update(delta):
	player.move_and_slide()

	if Input.is_action_just_pressed("attack"):
		attack_again = true
	if Input.is_action_just_pressed("dash") and AnimPlayer.frame >= dash_cancel_frame:
		transitioned.emit("dashing")

	player.handle_vertical_movement(player.get_gravity().y * delta)
	player.get_horizontal_input()
	if player.direction == player.facing:
		player.handle_horizontal_movement(player.AERIAL_SPEED - horizontal_friction)
	else:
		player.handle_horizontal_movement((player.AERIAL_SPEED - horizontal_friction)/3)
	if player.is_on_floor():
		# Case of unset variables
		if frame_teshold == -1 or ground_attck == "": 
			transitioned.emit("landing")
		# We check if we passed the treshold
		if player.anim_player.frame < frame_teshold:
			transitioned.emit(ground_attck)
		else:
			transitioned.emit("landing")

func exit():
	super.exit()
	player.friction = 0
# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if recovery_state_name == "":
		recovery_state_name = "airborne"
	if attack_again:
		if next_combo_state_name == "":
			AnimPlayer.play("fall")
			transitioned.emit("airborne")
		else:
			transitioned.emit(next_combo_state_name)
	else:
		AnimPlayer.play("fall")
		transitioned.emit("airborne")
