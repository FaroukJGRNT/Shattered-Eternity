extends AttackState

@export var x_move := 12
@export var y_move := -32

func enter():
	super.enter()
	player.global_position += Vector2(x_move * player.facing, y_move)
