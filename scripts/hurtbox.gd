extends Area2D
class_name HurtBox

var disabled := false
var daddy : LivingEntity

func _ready () -> void:
	if owner is LivingEntity:
		
		daddy = owner
	# Enemy hurtboxes need to be detected by the player
	collision_layer = 0
	collision_mask = 0
	if owner.is_in_group("Player"):
		set_collision_mask_value(2, true)
	elif owner.is_in_group("Enemy"):
		set_collision_mask_value(1, true)
	if owner.is_in_group("AllyProjectile"):
		set_collision_mask_value(2, true)
	elif owner.is_in_group("EnemyProjectile"):
		set_collision_mask_value(1, true)

	connect("area_entered", on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area == null:
		return

	if area is HitBox:
		if not daddy.has_method("take_damage"):
			return
		if not area.active or not _daddy_in_targeted_groups(daddy, area.targeted_groups):
			return
		if owner in area.affected_targets:
			return

		daddy.hit_listener.damage_taken(area)
		area.affected_targets.append(owner)

func _daddy_in_targeted_groups(diddy: Node, groups: Array) -> bool:
	for g in groups:
		if diddy.is_in_group(g):
			return true
	return false

func activate():
	set_deferred("monitoring", true)
	disabled = false

func desactivate():
	set_deferred("monitoring", false)
	disabled = true
