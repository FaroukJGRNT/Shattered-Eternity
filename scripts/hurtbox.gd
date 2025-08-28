extends Area2D
class_name HurtBox

var disabled := false
var timer := 1.0
var on_cooldown := false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	connect("area_entered", on_area_entered)

func _process(delta: float) -> void:
	if on_cooldown:
		timer -= delta
		if timer <= 0:
			on_cooldown = false

func on_area_entered(area:HitBox):
	if area == null:
		return
	if not owner.has_method("take_damage"):
		return
	if disabled == false and area.active and not on_cooldown and _owner_in_targeted_groups(owner, area.targeted_groups):
		owner.take_damage(area.damage)
		on_cooldown = true
	
func _owner_in_targeted_groups(owner: Node, groups: Array) -> bool:
	for g in groups:
		if owner.is_in_group(g):
			return true
	return false
