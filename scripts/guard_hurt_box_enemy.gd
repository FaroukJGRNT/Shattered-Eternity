extends HurtBox

func _ready() -> void:
	super._ready()
	monitoring = false
	disabled = true

func on_area_entered(area: Area2D) -> void:
	if area == null:
		return

	if area is HitBox:
		if area.active and _owner_in_targeted_groups(owner, area.targeted_groups):
			if area.is_parried:
				area.is_parried = false
				return
			var cam = get_tree().get_first_node_in_group("Camera")
			if cam:
				cam.trigger_shake(area.cam_shake_value, 10)

			if area.generate_damage().facing != owner.facing:
				area.is_parried = true
			else:
				return

			owner.velocity.x = (area.owner.facing * area.motion_value * 20)
