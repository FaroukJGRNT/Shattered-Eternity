extends  EnemyState

@export var acceleration = 0

func _init() -> void:
	is_state_blocking = true

func update(delta):
	if enemy.velocity.x > 0:
		enemy.velocity.x = max(enemy.velocity.x - acceleration, 0)
	if enemy.velocity.x < 0:
		enemy.velocity.x = min(enemy.velocity.x + acceleration, 0)
	enemy.move_and_slide()

func enter():
	enemy.velocity = Vector2(0, 0)
	AnimPlayer.play("guard")

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("explode")
