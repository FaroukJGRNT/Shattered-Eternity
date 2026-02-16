extends EnemyAttackState

var has_hot := false
var wave_scene : PackedScene = load("res://scenes/projectiles/bat_wave.tscn")

func enter():
	super.enter()
	has_hot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 13 and not has_hot:
		has_hot = true
		var wave : Projectile = Toolbox.spawn_projectile(owner, wave_scene)
		wave.set_target(owner.target)
