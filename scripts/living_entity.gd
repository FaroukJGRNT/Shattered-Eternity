extends CharacterBody2D
class_name LivingEntity

@export var max_life: int = 0
@export var life: int = 0
@export var attack : int = 0
@export var defense : int = 0

@export var thunder_res := 0
@export var fire_res := 0
@export var ice_res := 0

@export var max_mana := 0
@export var mana := 0

func take_damage(damage:int):
	var total_dmg = damage - defense
	if total_dmg <= 0:
		total_dmg = 0
	life -= total_dmg
	if life <= 0:
		life = 0
		die()

func deal_damage(motion_value:int):
	var total_dmg = motion_value + attack
	return total_dmg

func die():
	pass
