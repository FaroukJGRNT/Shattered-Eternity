extends HitListener

func damage_taken(area : HitBox) -> void:
	# Screen shake
	var cam = get_tree().get_first_node_in_group("Camera")
	if cam:
		cam.trigger_shake(area.cam_shake_value, 10)

	# Frame freeze
	frame_freeze(2)

	# Particles
	$GPUParticles2D.direction.x = area.facing
	$GPUParticles2D.emitting = true
	$GPUParticles2D.restart()

	# Taking damage and side effects
	# GETTING GUARD BROKEN
	if daddy.get_state() == "guard" and area.is_guard_break:
		# TODO : Big posture damage to add
		match daddy.poise_type:
			daddy.Poises.PLAYER:
				daddy.get_staggered()
			daddy.Poises.SMALL:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.MEDIUM:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.LARGE:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
		daddy.velocity.x = area.motion_value * area.facing * 20

	# Verify the hit (GUARD)
	# GUARD HANDLINGd
	if daddy.get_state() == "guard":
			return

	# GETTING INTERRUPTED
	if daddy.get_state() == "guardbreak" and area.is_phys_atk:
		# TODO : Big posture damage to add
		match daddy.poise_type:
			daddy.Poises.PLAYER:
				daddy.get_staggered()
			daddy.Poises.SMALL:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.MEDIUM:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.LARGE:
				daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
		daddy.velocity.x = area.motion_value * area.facing * 20

	if (daddy.get_state() != "staggered"):
		daddy.posture += area.motion_value / 3
	dmg = area.generate_damage()
	dmg = daddy.take_damage(dmg)

	# Call the hitbox side effect
	area.on_hit()
	
	match daddy.poise_type:
		daddy.Poises.PLAYER:
			print("PLAYER GETTING HURT")
			daddy.get_stunned(SMALL_PUSHBACK * area.facing, SMALL_PUSHBACK_DURATION)
		daddy.Poises.SMALL:
			match area.push_back:
				area.Pushback.NORMAL:
					daddy.get_stunned(SMALL_PUSHBACK * area.facing, SMALL_PUSHBACK_DURATION)
				area.Pushback.STRONG:
					daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
		daddy.Poises.MEDIUM:
			match area.push_back:
				area.Pushback.NORMAL:
					pass
				area.Pushback.STRONG:
					daddy.get_stunned(SMALL_PUSHBACK * area.facing, SMALL_PUSHBACK_DURATION)
		daddy.Poises.LARGE:
			pass
	
	# Hit flash
	daddy.anim_player.material.set_shader_parameter("enabled", true)
	shader_on_cooldown = true
	shader_duration = 0.2
	
	# TODO: Launch a vfx animation corresponding to the
	# caracteristics of the hit
	
	# Dictionnaire type -> couleur
	var dmg_colors = {
		"fire": Color.ORANGE,
		"thunder": Color.YELLOW,
		"ice": Color.CYAN,
		"phys": Color.WHITE
	}

	# Liste des dégâts et leur type
	var dmg_list = {
		"fire": dmg.fire_dmg,
		"thunder": dmg.thunder_dmg,
		"ice": dmg.ice_dmg,
		"phys": dmg.phys_dmg
	}

	# Pour chaque type de dégâts > 0, instancier le label avec la couleur correspondante
	for dmg_type in dmg_list.keys():
		var amount = dmg_list[dmg_type]
		if amount > 0:
			var dmg_text_instance = damage_label.instantiate()
			dmg_text_instance.position = Vector2(position.x + (dmg.facing * 5), position.y - 20)
			dmg_text_instance.direction = dmg.facing
			if owner.is_in_group("Player"):
				dmg_text_instance.add_theme_color_override("font_color", Color.INDIAN_RED)
			else:
				dmg_text_instance.add_theme_color_override("font_color", dmg_colors[dmg_type])
			dmg_text_instance.text = str(int(amount))  # affiche la valeur
			daddy.add_child(dmg_text_instance)

	# Critique
	if dmg.is_crit:
		var crit_text_instance = crit_label.instantiate()
		crit_text_instance.position = Vector2(position.x + (dmg.facing * 5), position.y - 30)
		crit_text_instance.direction = dmg.facing
		# On ne change pas le texte, le crit_label a son propre style
		daddy.add_child(crit_text_instance)

	# Lifebar update
	life_bar.update_health_bar(dmg.total_dmg)
