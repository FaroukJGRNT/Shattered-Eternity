extends Node

var vfx : PackedScene = load("res://scenes/short_lived_vfx.tscn")
var dummy_scene : PackedScene = load("res://scenes/dummy.tscn")

enum GameEvents  {
	PLAYER_DEAD,
	DUMMY_DEAD
}

func _ready() -> void:
	load_all_buffs()

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

#### ------------------------ THIS PART RELATES TO GAMEPLAY INFOS ---------------------- ####

# These variables are the chances to find a buff or a spell of a certain element
var fire_elemental_affinity := 1.0  
var ice_elemental_affinity := 1.0  
var thunder_elemental_affinity := 1.0

func roll_element() -> String:
	var total_weight = fire_elemental_affinity \
		+ ice_elemental_affinity \
		+ thunder_elemental_affinity
	
	if total_weight <= 0:
		return "none" # sécurité
	
	var roll = randf() * total_weight
	
	if roll < fire_elemental_affinity:
		return "fire"
	elif roll < fire_elemental_affinity + ice_elemental_affinity:
		return "ice"
	else:
		return "thunder"

var fire_spells : Array[Item] = [
	FireSpellItem.new()
]

var ice_spells : Array[Item] = [
	IceSpellItem.new()
]

var thunder_spells : Array[Item] = [
	ThunderSpellItem.new()
]

var elemental_buffs : Array[Buff] = []
var physical_buffs : Array[Buff] = []
var situational_buffs : Array[Buff] = []


func load_all_buffs():
	var dir1 = DirAccess.open("res://scripts/buffs/Elemental")
	var dir2 = DirAccess.open("res://scripts/buffs/Physical")
	var dir3 = DirAccess.open("res://scripts/buffs/Situational")
	
	if dir1:
		dir1.list_dir_begin()
		var file_name = dir1.get_next()
	
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script = load("res://scripts/buffs/Elemental/" + file_name)
				print(script)
				elemental_buffs.append(script.new())
				
			file_name = dir1.get_next()
	if dir2:
		dir2.list_dir_begin()
		var file_name = dir2.get_next()
	
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script = load("res://scripts/buffs/Physical/" + file_name)
				print(script)
				physical_buffs.append(script.new())

			file_name = dir2.get_next()
	if dir3:
		dir3.list_dir_begin()
		var file_name = dir3.get_next()
	
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script = load("res://scripts/buffs/Situational/" + file_name)
				print(script)
				situational_buffs.append(script.new())
				
			file_name = dir3.get_next()
	
	print(elemental_buffs[0].buff_name)
