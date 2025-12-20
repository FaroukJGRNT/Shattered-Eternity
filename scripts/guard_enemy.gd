extends EnemyState

var block_duration := 3.0
var cooldown := 0.0
var acceleration = 10

func _ready() -> void:
	is_state_blocking = true

func update(delta):
	if enemy.velocity.x > 0:
		enemy.velocity.x = max(enemy.velocity.x - acceleration, 0)
	if enemy.velocity.x < 0:
		enemy.velocity.x = min(enemy.velocity.x + acceleration, 0)
	enemy.move_and_slide()
	cooldown -= delta
	if cooldown <= 0 and enemy.velocity.x == 0:
		transitioned.emit("chase")

func enter():
	cooldown = block_duration
	enemy.velocity.x = 0
	AnimPlayer.play("guard")

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
