extends HurtBox
class_name ProjectileHurtBox

var real_daddy : Projectile

func _ready () -> void:
	real_daddy = owner
	# Enemy hurtboxes need to be detected by the player
	if real_daddy.is_in_group("ProjectileEnemy"):
		collision_layer = 2
	else:
		collision_layer = 0
	collision_mask = 2
	connect("area_entered", on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if area == null:
		return

	if area is HitBox:
		if not area.active or not _real_daddy_in_targeted_groups(real_daddy, area.targeted_groups):
			return
		if owner in area.affected_targets:
			return

		owner.on_hit()
		area.affected_targets.append(owner)

func _real_daddy_in_targeted_groups(diddy: Node, groups: Array) -> bool:
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
