extends EnemyAttackState

var ground_wave_scene : PackedScene = load("res://scenes/projectiles/golem_ground_wave.tscn")
var has_shot := false

func enter():
	super.enter()
	has_shot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 10 and has_shot == false:
		has_shot = true
		var ground_wave1 : Projectile = Toolbox.spawn_projectile(owner, ground_wave_scene, Vector2(0, 15))
		ground_wave1.direction = -1
		var ground_wave2 : Projectile = Toolbox.spawn_projectile(owner, ground_wave_scene, Vector2(0, 15))
		ground_wave2.direction = 1
