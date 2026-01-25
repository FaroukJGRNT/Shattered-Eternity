extends EnemyHitBox
class_name EnemyProjectileHitBox

func on_hit():
	owner.on_hit()
