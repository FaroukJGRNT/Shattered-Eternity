extends Area2D
class_name HurtBox

var disabled := false
var daddy : LivingEntity

func _ready () -> void:
	daddy = owner
	# Enemy hurtboxes need to be detected by the player
	if daddy.is_in_group("Enemy"):
		collision_layer = 2
	else:
		collision_layer = 0
	collision_mask = 2
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
