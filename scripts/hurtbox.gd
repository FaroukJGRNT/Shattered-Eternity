extends Area2D
class_name HurtBox

var disabled := false

func frame_freeze(scale: float = 0.1, duration: float = 0.1) -> void:
	# On ralentit le temps
	Engine.time_scale = scale

	var real_time_timer := get_tree().create_timer(duration)

	await real_time_timer.timeout
	# On remet le jeu à la vitesse normale
	Engine.time_scale = 1.0

func _ready () -> void:
	# Enemy hurtboxes need to be detected by the player
	if owner.is_in_group("Enemy"):
		collision_layer = 2
	else:
		collision_layer = 0
	collision_mask = 2
	connect("area_entered", on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area == null:
		return

	if area is HitBox:
		if not owner.has_method("take_damage"):
			return

		if area.active and _owner_in_targeted_groups(owner, area.targeted_groups):
			if area.is_parried:
				area.is_parried = false
				print("Successfully parried")
				return
			var cam = get_tree().get_first_node_in_group("Camera")
			if cam:
				cam.trigger_shake(area.cam_shake_value, 10)
			print(area.hitstop_scale, area.hitstop_time)
			frame_freeze(area.hitstop_scale, area.hitstop_time)
			owner.take_damage(area.generate_damage())
			print("Took damage")

func _owner_in_targeted_groups(owner: Node, groups: Array) -> bool:
	for g in groups:
		if owner.is_in_group(g):
			return true
	return false
