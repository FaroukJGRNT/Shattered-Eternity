extends EnemyState

var push_back := 0
var deceleration := 2.0
var timeout := 0.0
var timer := 0.0

func _init() -> void:
	is_state_blocking = true

func enter():
	super.enter()
	AnimPlayer.play("stun")
	timer = timeout
	enemy.velocity.x = push_back

func update(delta):
	if enemy.velocity.x > 0:
		enemy.velocity.x = max(enemy.velocity.x - deceleration * 100 * delta, 0)
	elif enemy.velocity.x < 0:
		enemy.velocity.x = min(enemy.velocity.x + deceleration * 100 * delta, 0)

	timer -= delta
	if timer <= 0:
		transitioned.emit("decide")
	enemy.move_and_slide()
