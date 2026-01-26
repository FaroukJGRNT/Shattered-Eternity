extends AttackState

var projectile_scene : PackedScene = load("res://scenes/spear_projectile.tscn")
var MAX_RANGE = 600
var shot = false

func get_closest_enemy() -> Array:
	var closest_enemy = null
	var closest_dist = INF
	
	var my_pos = owner.global_position
	var facing_dir = owner.transform.x.normalized()  # direction du joueur
	# Si ton joueur utilise rotation, tu peux aussi faire :
	# var facing_dir = Vector2.RIGHT.rotated(owner.global_rotation)
	
	var MAX_ANGLE = deg_to_rad(60) # champ de vision de 90° (45° à gauche/droite)
	var VERTICAL_LIMIT = 50        # tolérance en hauteur

	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var dir_to_enemy = (enemy.global_position - my_pos).normalized()
		if sign(dir_to_enemy.x) != sign(player.facing):
			continue
		
		var dist = my_pos.distance_to(enemy.global_position)

		# 1. Vérifie si l’ennemi est dans le cône devant
		var angle_to_enemy = facing_dir.angle_to(dir_to_enemy)
		if angle_to_enemy > MAX_ANGLE:
			continue  # trop décalé sur la gauche/droite

		# 2. Vérifie la différence verticale
		if abs(enemy.global_position.y - my_pos.y) > VERTICAL_LIMIT:
			continue  # trop haut ou trop bas

		# 3. Choisir le plus proche
		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = enemy

	return [closest_enemy, closest_dist]

func enter():
	super.enter()
	shot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame == 2 and !shot:
		shot = true
		var projectile = projectile_scene.instantiate()
		projectile.set_premade_damage(owner)
		get_tree().current_scene.add_child(projectile) # recommandé
		projectile.global_position = owner.global_position
		projectile.position.y -= 10
		projectile.direction.x = player.facing
		projectile.scale.x = player.facing
		projectile.scale.y = player.facing
		var results = get_closest_enemy()
		var enemy = results[0]
		var dist = results[1]

		if enemy != null and dist < MAX_RANGE:
			projectile.set_target(enemy)
