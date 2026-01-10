extends AttackState

var charge_timer := 0.0

func enter():
	super.enter()
	charge_timer = 0.0

func update(delta):
	super.update(delta)


	if Input.is_action_pressed("attack"):
		charge_timer += delta
	else:
		charge_timer = 0.0

	if charge_timer >= 0.20:
		transitioned.emit("spearcharging")
		return
