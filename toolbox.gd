extends Node

var vfx : PackedScene = load("res://scenes/short_lived_vfx.tscn")

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
