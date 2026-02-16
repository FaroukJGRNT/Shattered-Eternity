extends EnemyAttackState

var proj : PackedScene = load("res://scenes/projectiles/spirit_spit.tscn")

var has_shot : bool = false

func enter():
	super.enter()
	has_shot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame >= 7 and not has_shot:
		has_shot = true
		var spit : SpiritSpit = Toolbox.spawn_projectile(owner, proj)
		spit.facing =  owner.facing
		spit.HORIZ_VELOCITY = max(abs(enemy.position.x - enemy.target.position.x) * 1.5, 30)
		if spit.HORIZ_VELOCITY > 350:
			spit.HORIZ_VELOCITY = 350
