extends Node

var vfx : PackedScene = load("res://scenes/short_lived_vfx.tscn")
var dummy_scene : PackedScene = load("res://scenes/dummy.tscn")

enum GameEvents  {
	PLAYER_DEAD,
	DUMMY_DEAD
}

func _ready() -> void:
	load_all_buffs()
	var world_root = get_tree().current_scene.get_node("WorldRoot")
	if world_root:
		call_deferred("generate_world")

func _process(delta: float) -> void:
	if transitioning:
		trans_timer -= delta
		if trans_timer <= 0:
			transitioning = false

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

func remove_player_and_ui(level : Node2D):
	# Supprime Player/UI par défaut du nouveau level
	for child in level.get_children():
		if child.is_in_group("Player") or child.is_in_group("UI"):
			child.queue_free()
	
var transitioning := false
var trans_cooldown := 3.0
var trans_timer := 0.0

func load_level(new_level: Node2D, output_position: Vector2):
	print("TRANSITIONING to level : ", new_level)
	transitioning = true

	remove_player_and_ui(new_level)

	var play = get_tree().get_first_node_in_group("Player")
	print("Player grabbed: ", play)
	var ui = get_tree().get_first_node_in_group("UI")
	var world_root = get_tree().current_scene.get_node("WorldRoot")
	print("World root grabbed: ", world_root)
	
	var current_level = get_tree().get_first_node_in_group("Level")
	print("Current level: ", current_level)

	# Retire l’ancienne room du tree (sans la détruire)
	if current_level:
		current_level.remove_child(play)
		current_level.remove_child(ui)
		world_root.remove_child(current_level)

	# Ajoute la nouvelle si nécessaire
	if new_level.get_parent() == null:
		print("Adding new room to the world root: ", new_level)
		world_root.add_child(new_level)

	new_level.add_child(play)
	print("Player added")
	new_level.add_child(ui)

	play.position = output_position

	trans_timer = trans_cooldown
	
	var linked_scene = get_level_output_connectors(new_level)[0].linked_room
	print("The room we just entered leads to: ", linked_scene)


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

var start_level : PackedScene = load("res://scenes/levels/level_1.tscn")
var world_length := 7

var available_levels : Array [PackedScene] = [
	load("res://scenes/levels/level_4.tscn"),
	load("res://scenes/levels/level_3.tscn"),
	load("res://scenes/levels/level_1.tscn"),
	load("res://scenes/levels/level_2.tscn"),
]

func connect_outputs(level : Node2D, depth : int):
	if depth <= 1:
		return
	for output in get_level_output_connectors(level):
		# Instantiate the output room
		var output_level_scene = available_levels[randi_range(0, len(available_levels) - 1)].instantiate()
		print("Adding room: ", output_level_scene.name)
		# Get the output room input
		var output_room_entrance = get_level_input_connector(output_level_scene)
		# Link the spawnpoints
		output.output_position = output_room_entrance.input_spawn_point.position
		output_room_entrance.output_position = output.input_spawn_point.position
		# Link the room itself
		output.linked_room = output_level_scene
		output_room_entrance.linked_room = level
		# Repeat the process for the newly created_room
		connect_outputs(output_level_scene, depth - 1)

func generate_world():
	var start_level_scene = start_level.instantiate()
	var world_root = get_tree().current_scene.get_node("WorldRoot")
	world_root.add_child(start_level_scene)

	connect_outputs(start_level_scene, world_length)
	
	var curr_scene : Node2D = start_level_scene
	while get_level_output_connectors(curr_scene)[0].linked_room != null:
		print("Room ", curr_scene, " leads to ", get_level_output_connectors(curr_scene)[0].linked_room)
		curr_scene = get_level_output_connectors(curr_scene)[0].linked_room
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
				elemental_buffs.append(script.new())
				
			file_name = dir1.get_next()
	if dir2:
		dir2.list_dir_begin()
		var file_name = dir2.get_next()
	
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script = load("res://scripts/buffs/Physical/" + file_name)
				physical_buffs.append(script.new())

			file_name = dir2.get_next()
	if dir3:
		dir3.list_dir_begin()
		var file_name = dir3.get_next()
	
		while file_name != "":
			if file_name.ends_with(".gd"):
				var script = load("res://scripts/buffs/Situational/" + file_name)
				situational_buffs.append(script.new())
				
			file_name = dir3.get_next()
	
