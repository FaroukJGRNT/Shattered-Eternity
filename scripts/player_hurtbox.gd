extends HurtBox
class_name PlayerHurtBox

var disabled := false
var timer := 1.0
var on_cooldown := false

func _process(delta: float) -> void:
	if on_cooldown:
		timer -= delta
		if timer <= 0:
			on_cooldown = false
			timer = 1.0

func on_area_entered(area: Area2D) -> void:
	print("Hit detected, disabled is", disabled)
	if area == null:
		return

	# HitBox
	if area is HitBox:
		if not owner.has_method("take_damage"):
			return
		if disabled == false and area.active and not on_cooldown and _owner_in_targeted_groups(owner, area.targeted_groups):
			owner.take_damage(area.damage)
			on_cooldown = true

	# HurtBox
	elif area is HurtBox:
		if area.owner.is_in_group("Enemy") and disabled == false:
			owner.take_damage(10)
			on_cooldown = true
