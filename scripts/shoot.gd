extends EnemyAttackState

var has_hot := false
var wave_scene : PackedScene = load("res://scenes/projectiles/golemite_projectile.tscn")

@export var front_gap := 30
@export var vertical_gap := 8
@export var rotation_jump := 10

func enter():
	super.enter()
	has_hot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame >= 6 and not has_hot:
		if not enemy.is_target_in_front():
			enemy.turn_around()

	if AnimPlayer.frame >= 6 and not has_hot:
		has_hot = true

		var facing : int = owner.facing

		# WAVE 1
		var wave1: Projectile = Toolbox.spawn_projectile(owner, wave_scene, Vector2(front_gap * facing, vertical_gap))
		wave1.direction = Vector2.RIGHT * facing

		# WAVE 2
		var wave2: Projectile = Toolbox.spawn_projectile(owner, wave_scene, Vector2(front_gap * facing, vertical_gap))
		wave2.rotation_degrees = rotation_jump * -facing
		wave2.direction = Vector2.RIGHT.rotated(deg_to_rad(-rotation_jump)) * Vector2(facing, 1)

		# WAVE 3
		var wave3: Projectile = Toolbox.spawn_projectile(owner, wave_scene, Vector2(front_gap * facing, vertical_gap))
		wave3.rotation_degrees = rotation_jump * -facing
		wave3.direction = Vector2.RIGHT.rotated(deg_to_rad(rotation_jump * -2)) * Vector2(facing, 1)
