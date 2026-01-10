extends Node

func spawn_projectile(scene_path: String, owner_entity, pos: Vector2, dir_angle: float = 0.0):
	var scene: PackedScene = load(scene_path)
	var proj = scene.instantiate()
	proj.global_position = pos
	proj.rotation = dir_angle
	if proj.has_method("set_premade_damage"):
		proj.set_premade_damage(owner_entity)
	get_tree().current_scene.add_child(proj)
	return proj