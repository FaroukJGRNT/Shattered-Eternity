extends Area2D
class_name HitBox

var damage = 10
var cam_shake_value:float = 0
var hitstop_time = 0
var hitstop_scale = 1
var active = false
var targeted_groups = []

func _init() -> void:
	monitoring = false
	collision_layer = 2
	collision_mask = 0
