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
