extends EnemyAttackState

var has_hot := false
var wave_scene : PackedScene = load("res://scenes/bat_wave.tscn")

func enter():
	super.enter()
	has_hot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 13 and not has_hot:
		has_hot = true
		var wave : Projectile = wave_scene.instantiate()
		add_child(wave) # recommandé
		wave.global_position = owner.global_position
		wave.set_premade_damage(owner)
