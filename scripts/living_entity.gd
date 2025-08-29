extends CharacterBody2D
class_name LivingEntity

@export var max_life: int
@export var life: int
@export var attack = 0
@export var defense = 0

func take_damage(damage:int):
	var total_dmg = damage - defense
	if total_dmg <= 0:
		total_dmg = 0
	life -= total_dmg
	if life <= 0:
		life = 0
		die()

func deal_damage(motion_value:int):
	var total_dmg = motion_value * attack
	return total_dmg

func die():
	pass
