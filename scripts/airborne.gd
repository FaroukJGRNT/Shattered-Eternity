extends PlayerState

var added_horiz_speed = 0.0
var coyote_time = 0.12

func enter():
	AnimPlayer.play("jump")
	coyote_time = 0.12

func update(delta):
	#if %RayCast2D.is_colliding():
		#transitioned.emit("wallsliding")
		#return

	# Jump peak
	coyote_time -= delta
	
	if Input.is_action_just_pressed("jump"):
		if coyote_time > 0.0 and player.allowed_jumps > 0 and get_parent().old_state.name == "Running":
			player.allowed_jumps = 0
			transitioned.emit("jumpstart")
			return

	# when at peak height, reduce gravity, add horizontal speed
	if abs(player.velocity.y) < 50:
		added_horiz_speed = 25.0
		#AnimPlayer.play("jump_peak")
		player.handle_vertical_movement((player.get_gravity().y) / 1.5 * delta)
	else:
		player.handle_vertical_movement(player.get_gravity().y * delta)
		added_horiz_speed = 0.0
	# Change animation to fall when descending
	if player.velocity.y > 0:
		AnimPlayer.play("fall")
	player.initiate_slide()
	player.handle_horizontal_movement(player.AERIAL_SPEED + added_horiz_speed)
	if Input.is_action_just_pressed("attack") and not player.aerial_attack_used:
		player.aerial_attack_used = false
		match player.current_weapon:
			player.Weapons.SPEAR:
				transitioned.emit("spearaerial")
			player.Weapons.SWORD:
				transitioned.emit("swordaerial1")
			player.Weapons.HAMMER:
				pass
func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
