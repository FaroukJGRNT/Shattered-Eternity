extends Area2D
class_name HurtBox

var disabled := false
var timer := 1.0
var on_cooldown := false

func _ready() -> void:
	if owner.is_in_group("Enemy"):
		collision_layer = 2
	else:
		collision_layer = 0
	collision_mask = 2
	connect("area_entered", on_area_entered)

func _process(delta: float) -> void:
	if on_cooldown:
		timer -= delta
		if timer <= 0:
			on_cooldown = false

func on_area_entered(area: Area2D) -> void:
	if area == null:
		return

	# Cas HitBox
	if area is HitBox:
		if not owner.has_method("take_damage"):
			return
		if not disabled and area.active and not on_cooldown and _owner_in_targeted_groups(owner, area.targeted_groups):
			owner.take_damage(area.damage)
			on_cooldown = true

	# Cas HurtBox
	elif area is HurtBox:
		if area.owner.is_in_group("Enemy") and owner.is_in_group("Player") and not disabled:
			owner.take_damage(10)
			on_cooldown = true

func _owner_in_targeted_groups(owner: Node, groups: Array) -> bool:
	for g in groups:
		if owner.is_in_group(g):
			return true
	return false
