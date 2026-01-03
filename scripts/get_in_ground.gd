extends EnemyAttackState

var ground_wave_scene : PackedScene = load("res://scenes/golem_ground_wave.tscn")
var has_shot := false

func enter():
	super.enter()
	has_shot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 10 and has_shot == false:
		has_shot = true
		var ground_wave1 : Projectile = ground_wave_scene.instantiate()
		ground_wave1.direction = -1
		var ground_wave2 : Projectile = ground_wave_scene.instantiate()
		ground_wave2.direction = 1
		get_tree().current_scene.add_child(ground_wave1) # recommandé
		ground_wave1.global_position = owner.global_position
		ground_wave1.position.y += 15
		get_tree().current_scene.add_child(ground_wave2) # recommandé
		ground_wave2.global_position = owner.global_position
		ground_wave2.position.y += 15
		
		ground_wave1.set_premade_damage(owner)
		ground_wave1.set_premade_damage(owner)
		ground_wave2.set_premade_damage(owner)
