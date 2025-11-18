extends Node2D
class_name Projectile

@export var is_destructible := false
@export var is_one_shot := true
var target : LivingEntity

func move(delta):
	pass

func set_target(_target : LivingEntity):
	target = _target

func on_hit():
	pass

func _process(delta: float) -> void:
	move(delta)
