extends Node

var vfx : PackedScene = load("res://scenes/short_lived_vfx.tscn")
var dummy_scene : PackedScene = load("res://scenes/dummy.tscn")

enum GameEvents  {
	PLAYER_DEAD,
	DUMMY_DEAD
}

func hit_freeze(duration := 0.08, scale := 0.1) -> void:
	Engine.time_scale = scale
	await get_tree().create_timer(duration, true).timeout
	Engine.time_scale = 1.0

func spawn_projectile(spawner : Node2D, projectile_scene : PackedScene, offset : Vector2 = Vector2.ZERO) -> Projectile:
	var projectile_instance = projectile_scene.instantiate() as Projectile
	projectile_instance.position = spawner.global_position + offset
	get_tree().get_first_node_in_group("Level").add_child(projectile_instance)
	projectile_instance.set_premade_damage(spawner)
	return projectile_instance

func spawn_vfx(spawner : Node2D, animation : String, offset : Vector2 = Vector2.ZERO) -> Node2D:
	var vfx_instance = vfx.instantiate() as ShortLivedVFX
	vfx_instance.position = spawner.global_position + offset
	get_tree().get_first_node_in_group("Level").add_child(vfx_instance)
	vfx_instance.play(animation)
	return vfx_instance

func get_nearest_from_group(group_name: String, source : Node2D) -> Node2D:
	var nearest = null
	var nearest_dist = INF

	for node in get_tree().get_nodes_in_group(group_name):
		if not node is Node2D:
			continue

		var d = source.global_position.distance_to(node.global_position)

		if d < nearest_dist:
			nearest_dist = d
			nearest = node

	return nearest

func get_child_by_name(parent, name: String):
	for c in parent.get_children():
		if c.name == name:
			return c
	return null

func handle_event(event : GameEvents, emitter : Node2D):
	match event:
		GameEvents.PLAYER_DEAD:
			# Find nearest checkpoint
			var nearest_cp = get_nearest_from_group("PlayerSpawnPoint", emitter)
			# Move the player
			emitter.global_position = nearest_cp.global_position
			# Put him full life
			emitter.life = emitter.max_life
			emitter.dead = false
			emitter.change_state("idle")
			var health_bar = get_child_by_name(get_tree().get_first_node_in_group("UI"), "LifeBar2")
			health_bar.update_health_bar(0)
		
		GameEvents.DUMMY_DEAD:
			# Instantiate a new one at the same place
			var dummy = dummy_scene.instantiate()
			get_tree().get_first_node_in_group("Level").add_child(dummy)
			dummy.position = emitter.position
