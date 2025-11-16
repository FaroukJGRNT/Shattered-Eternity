extends AttackState

func get_closest_enemy() -> Node2D:
	var closest_enemy = null
	var closest_dist = INF  # distance infinie par défaut
	var my_pos = owner.global_position

	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var dist = my_pos.distance_to(enemy.global_position)

		if dist < closest_dist:
			closest_dist = dist
			closest_enemy = enemy

	return closest_enemy

func enter():
	get_tree().add
