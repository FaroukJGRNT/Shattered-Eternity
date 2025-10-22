extends AttackState

var charge_timer := 0.0

func enter():
	super.enter()
	charge_timer = 0.0

func update(delta):
	super.update(delta)
	# Handle charged attack
	if Input.is_action_pressed("attack"):
		charge_timer += delta
	else:
		charge_timer = 0.0
		
	if charge_timer >= 0.20:
		transitioned.emit("hammercharging")
		return

	player.handle_horizontal_movement(player.RUN_SPEED / 8)
