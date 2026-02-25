extends AttackState

func enter():
	super.enter()
	player.velocity = Vector2(0, -30)

func on_animation_end():
	transitioned.emit("ledgeclimb")
