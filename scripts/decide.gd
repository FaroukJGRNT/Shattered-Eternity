extends EnemyState

func enter():
	enemy.velocity.y = 0
	AnimPlayer.play("idle")
