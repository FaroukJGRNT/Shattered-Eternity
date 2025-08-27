extends Area2D
class_name HurtBox

var disabled := false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	connect("area_entered", on_area_entered)

func on_area_entered(area:HitBox):
	if area == null:
		return
	if not owner.has_method("take_damage"):
		return
	if disabled == false:
		owner.take_damage(area.damage)
