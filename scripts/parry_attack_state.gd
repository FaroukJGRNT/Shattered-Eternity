extends AttackState
class_name ParryAttackState

func enter():
	super.enter()
	player.hurtbox.desactivate()

func exit():
	super.exit()
	player.hurtbox.activate()
