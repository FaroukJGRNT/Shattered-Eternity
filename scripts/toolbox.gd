extends Node

var vfx : PackedScene = load("res://scenes/short_lived_vfx.tscn")
var dummy_scene : PackedScene = load("res://scenes/dummy.tscn")

enum GameEvents  {
	PLAYER_DEAD,
	DUMMY_DEAD,
	CHECKPOINT_REACHED
}

func _ready() -> void:
	load_all_buffs()
	load_all_spells()
	var world_root = get_tree().current_scene.get_node("WorldRoot")
	if world_root:
		call_deferred("generate_world")

func set_active_recursive(node: Node, active: bool):
	node.set_process(active)
	node.set_physics_process(active)

	node.set_process_input(active)
	node.set_process_unhandled_input(active)
	
	for child in node.get_children():
		set_active_recursive(child, active)

var ui_mode = false
var spell_equip_scene : PackedScene = load("res://ui/molecules/spell_equip.tscn")

func _process(delta: float) -> void:
	if transitioning:
		trans_timer -= delta
		if trans_timer <= 0:
			transitioning = false

	#var player = get_tree().get_first_node_in_group("Player")
#
	#if Input.is_action_just_pressed("inventory") and not ui_mode:
		#var modal = ui_manager.show_modal(spell_equip_scene)
		#ui_mode = true
	#if ui_mode and player:
		#print("Blocked")
		#set_active_recursive(player, false)
	#elif not ui_mode and player:
		#set_active_recursive(player, true)

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

func spawn_anything(spawner : Node2D, scene_to_spawn : PackedScene, offset : Vector2 = Vector2.ZERO):
	var instance = scene_to_spawn.instantiate()
	instance.position = spawner.global_position + offset
	get_tree().get_first_node_in_group("Level").add_child(instance)
	return instance

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

var last_check_room : Node2D
var last_check_pos : Vector2

func return_to_checkpoint():
	if not last_check_pos or not last_check_pos:
		return
	load_level(last_check_room, last_check_pos)

func handle_event(event : GameEvents, emitter : Node2D):
	match event:
		GameEvents.PLAYER_DEAD:
			return_to_checkpoint()
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

		GameEvents.CHECKPOINT_REACHED:
			last_check_room = get_tree().get_first_node_in_group("Level")
			last_check_pos = get_tree().get_first_node_in_group("Player").global_position

func remove_player_and_ui(level : Node2D):
	# Supprime Player/UI par défaut du nouveau level
	for child in level.get_children():
		if child.is_in_group("Player") or child.is_in_group("UI"):
			child.queue_free()
	
var transitioning := false
var trans_cooldown := 0.8
var trans_timer := 0.0


func load_level(new_level: Node2D, output_position: Vector2):
	transitioning = true

	remove_player_and_ui(new_level)

	var play = get_tree().get_first_node_in_group("Player")
	var ui = get_tree().get_first_node_in_group("UI")
	var world_root = get_tree().current_scene.get_node("WorldRoot")
	
	var current_level = get_tree().get_first_node_in_group("Level")

	# Retire l’ancienne room du tree (sans la détruire)
	if current_level:
		current_level.remove_child(play)
		current_level.remove_child(ui)
		world_root.remove_child(current_level)

	# Ajoute la nouvelle si nécessaire
	if new_level.get_parent() == null:
		world_root.add_child(new_level)

	new_level.add_child(play)
	new_level.add_child(ui)

	play.position = output_position

	trans_timer = trans_cooldown


func get_level_input_connector(level : Node2D) -> Connector:
	for c in level.get_children():
		if c is Connector and c.connector_type == Connector.ConnectorType.INPUT:
			return c
	return null

func get_level_output_connectors(level : Node2D) -> Array[Connector]:
	var connectors : Array[Connector] = []
	for c in level.get_children():
		if c is Connector and c.connector_type == Connector.ConnectorType.OUTPUT:
			connectors.append(c)
	return connectors

var start_level : PackedScene = load("res://scenes/levels/start_room.tscn")
var end_level : PackedScene = load("res://scenes/levels/end_room.tscn")
var rest_room : PackedScene = load("res://scenes/levels/rest_room.tscn")
var merchant_room : PackedScene = load("res://scenes/levels/merchant_room.tscn")

var easy_levels : Array[PackedScene] = []
var medium_levels : Array[PackedScene] = []
var hard_levels : Array[PackedScene] = []

var lap_length := 4

func load_scenes_from_dir(path: String) -> Array[PackedScene]:
	var scenes : Array[PackedScene] = []
	
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Cannot open directory: " + path)
		return scenes
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tscn"):
			var full_path = path + "/" + file_name
			var scene := load(full_path) as PackedScene
			
			if scene:
				scenes.append(scene)
			else:
				push_warning("Failed to load scene: " + full_path)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return scenes

func connect_outputs(level : Node2D, depth : int):
	var output_level_scene
	if depth < 1:
		return level
	for output in get_level_output_connectors(level):
		# Instantiate the output room
		if depth >= 3:
			output_level_scene = easy_levels[randi_range(0, len(easy_levels) - 1)].instantiate()
		elif depth == 2:
			output_level_scene = medium_levels[randi_range(0, len(medium_levels) - 1)].instantiate()
		elif depth == 1:
			output_level_scene = hard_levels[randi_range(0, len(hard_levels) - 1)].instantiate()
		else:
			print("No depth matching")
		# Get the output room input
		var output_room_entrance = get_level_input_connector(output_level_scene)
		# Link the spawnpoints
		output.output_position = output_room_entrance.input_spawn_point.position
		output_room_entrance.output_position = output.input_spawn_point.position
		# Link the room itself
		output.linked_room = output_level_scene
		output_room_entrance.linked_room = level
		# Repeat the process for the newly created_room
		output_level_scene = connect_outputs(output_level_scene, depth - 1)

	return output_level_scene

func link_rooms(room1 : Node2D, room2 : Node2D):
	var room1_exit = get_level_output_connectors(room1)[0]
	var room2_entrance = get_level_input_connector(room2)
	# Link the spawnpoints
	room1_exit.output_position = room2_entrance.input_spawn_point.position
	room2_entrance.output_position = room1_exit.input_spawn_point.position
	# Link the room itself
	room1_exit.linked_room = room2
	room2_entrance.linked_room = room1

func generate_world():
	easy_levels = load_scenes_from_dir("res://scenes/levels/easy_rooms")
	medium_levels = load_scenes_from_dir("res://scenes/levels/medium_rooms")
	hard_levels = load_scenes_from_dir("res://scenes/levels/hard_rooms")

	var start_level_scene = start_level.instantiate()
	var world_root = get_tree().current_scene.get_node("WorldRoot")
	world_root.add_child(start_level_scene)

	# Lap 1
	var last_level = connect_outputs(start_level_scene, lap_length)
	var rest_level = rest_room.instantiate()
	link_rooms(last_level, rest_level)
	# Lap 2
	last_level = connect_outputs(rest_level, lap_length)
	rest_level = rest_room.instantiate()
	link_rooms(last_level, rest_level)
	# Lap 3
	last_level = connect_outputs(rest_level, lap_length)
	rest_level = rest_room.instantiate()
	link_rooms(last_level, rest_level)
	# Lap 4
	last_level = connect_outputs(rest_level, lap_length)
	rest_level = end_level.instantiate()
	link_rooms(last_level, rest_level)

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

var fire_spells : Array[Item] = []

var ice_spells : Array[Item] = []

var thunder_spells : Array[Item] = []

func load_all_spells():
	var icon_path = "res://assets/spell_item_icons/"
	var start_path = "res://scripts/spell_items/"
	var dir = DirAccess.open("res://scripts/spell_items")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script = load(start_path + file_name)
				var new_instance : SpellItem = script.new()
				# 🔹 Récupérer le nom sans extension
				var item_name = file_name.get_basename()
				# 🔹 Construire le chemin de l'icône
				var icon_file = icon_path + item_name + ".png"
				print(file_name)
				print(icon_file)
				# 🔹 Vérifier si l'icône existe
				if FileAccess.file_exists(icon_file):
					new_instance.item_icon = load(icon_file)
				else:
					print("Icon not found for spell:", item_name)
				if new_instance.spell_type == SpellItem.SpellType.FIRE:
					fire_spells.append(new_instance)
				if new_instance.spell_type == SpellItem.SpellType.ICE:
					ice_spells.append(new_instance)
				if new_instance.spell_type == SpellItem.SpellType.THUNDER:
					thunder_spells.append(new_instance)

			file_name = dir.get_next()

var elemental_buffs : Array[Buff] = []
var physical_buffs : Array[Buff] = []
var situational_buffs : Array[Buff] = []

func get_buffes_from_dir(dir: DirAccess, start_path: String, icon_path: String) -> Array[Buff]:
	var buffes : Array[Buff] = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script = load(start_path + file_name)
				var new_instance : Buff = script.new()
				# 🔹 Récupérer le nom sans extension
				var item_name = file_name.get_basename()
				# 🔹 Construire le chemin de l'icône
				var icon_file = icon_path + item_name + ".png"
				print(file_name)
				print(icon_file)
				# 🔹 Vérifier si l'icône existe
				if FileAccess.file_exists(icon_file):
					new_instance.item_icon = load(icon_file)
				else:
					print("Icon not found for buff:", item_name)
				buffes.append(new_instance)
			file_name = dir.get_next()
	return buffes

func load_all_buffs():
	var dir1 = DirAccess.open("res://scripts/buffs/Elemental")
	var dir2 = DirAccess.open("res://scripts/buffs/Physical")
	var dir3 = DirAccess.open("res://scripts/buffs/Situational")
	
	var icon_dir = "res://assets/buff_icons/"
	
	elemental_buffs = get_buffes_from_dir(dir1, "res://scripts/buffs/Elemental/", icon_dir)
	physical_buffs = get_buffes_from_dir(dir2, "res://scripts/buffs/Physical/", icon_dir)
	situational_buffs = get_buffes_from_dir(dir3, "res://scripts/buffs/Situational/", icon_dir)
