extends Area2D
class_name HitBox

var damage = 10
var active = false
var targeted_groups = []

func _init() -> void:
	monitoring = false
	collision_layer = 2
	collision_mask = 0
