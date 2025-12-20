extends EnemyState

var push_back := 0
var deceleration := 5.0
var timer := 1.0

func _init() -> void:
	is_state_blocking = true

func enter():
	super.enter()
	AnimPlayer.play("stun")
	timer = 1.0
	push_back = -400.0 * enemy.facing
	enemy.velocity.x = push_back
	print("Enemy veloc: ", enemy.velocity.x)

func update(delta):
	print("Enemy veloc: ", enemy.velocity.x)
	if enemy.velocity.x > 0:
		enemy.velocity.x -= deceleration
	elif enemy.velocity.x < 0:
		enemy.velocity.x += deceleration

	timer -= delta
	if timer <= 0:
		transitioned.emit("chase")
	enemy.move_and_slide()
