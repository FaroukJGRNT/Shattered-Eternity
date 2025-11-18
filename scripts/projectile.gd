extends Node2D
class_name Projectile

@export var is_destructible := false
@export var is_one_shot := true
var target : LivingEntity

func set_target(_target : LivingEntity):
	target = _target

func move(delta):
	pass

func on_hit():
	pass

func _process(delta: float) -> void:
	move(delta)
	if position.distance_to(get_tree().get_first_node_in_group("Player").position) > 2000:
		queue_free()
