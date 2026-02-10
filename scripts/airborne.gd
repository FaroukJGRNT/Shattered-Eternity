extends PlayerState

var added_horiz_speed = 0.0
var coyote_time = 0.12

func enter():
	AnimPlayer.play("jump")
	coyote_time = 0.12

func update(delta):
	if %RayCast2D.is_colliding():

		var collider = %RayCast2D.get_collider()

		# ✅ On vérifie bien une TileMapLayer
		if collider is TileMapLayer:

			var tilemap: TileMapLayer = collider

			# Position du point d'impact en coordonnées monde
			var hit_pos = %RayCast2D.get_collision_point()

			# Convertir en coordonnée de tuile (cellule)
			var cell = tilemap.local_to_map(hit_pos)

			# Récupérer les données de la tuile touchée
			var tile_data = tilemap.get_cell_tile_data(cell)

			if tile_data and tile_data.get_custom_data("WallSlideFacingRight") == true:
				player.facing = 1
				player.direction = 1
				transitioned.emit("wallsliding")
				return
			elif tile_data and tile_data.get_custom_data("WallSlideFacingLeft") == true:
				player.facing = -1
				player.direction = -1
				transitioned.emit("wallsliding")
				return

	# Jump peak
	coyote_time -= delta
	
	if Input.is_action_just_pressed("jump"):
		if coyote_time > 0.0 and player.allowed_jumps > 0 and get_parent().old_state.name == "Running":
			player.allowed_jumps = 0
			transitioned.emit("jumpstart")
			return

	# when at peak height, reduce gravity, add horizontal speed
	if abs(player.velocity.y) < 50 and player.state_machine.old_state.name.to_lower() != "wallsliding":
		print("Low fall veloc")
		added_horiz_speed = 25.0
		#AnimPlayer.play("jump_peak")
		player.handle_vertical_movement((player.get_gravity().y) / 1.5 * delta)
	else:
		player.handle_vertical_movement(player.get_gravity().y * delta)
		added_horiz_speed = 0.0
	# Change animation to fall when descending
	if player.velocity.y > 0 and AnimPlayer.animation != "fall":
		AnimPlayer.play("fall")
	player.initiate_slide()
	player.handle_horizontal_movement(player.AERIAL_SPEED + added_horiz_speed, delta)
	if Input.is_action_just_pressed("attack") and not player.aerial_attack_used:
		player.aerial_attack_used = false
		match player.current_weapon:
			player.Weapons.SPEAR:
				transitioned.emit("spearaerial")
			player.Weapons.SWORD:
				transitioned.emit("swordaerial1")
			player.Weapons.HAMMER:
				transitioned.emit("hammeraerial")
	player.move_and_slide()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
