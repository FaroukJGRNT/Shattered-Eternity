extends Projectile

# Lightning bolt: applies shock and chains to nearby enemies
@export var speed := 700
@export var chain_range := 140
@export var chain_count := 2

func _ready() -> void:
	if anim_player:
		anim_player.play()

func move(delta):
	if destroyed:
		return
	var forward := Vector2.UP.rotated(rotation)
	global_position += forward * speed * delta

func set_premade_damage(entity : LivingEntity):
	if has_node("HitBox"):
		$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, "full_thunder")

var _chain_origin : Node = null

func _chain_shock(origin_entity : Node):
	# Find nearest enemies within chain_range (excluding origin_entity)
	var candidates := []
	for e in get_tree().get_nodes_in_group("Enemy"):
		if e != origin_entity:
			if e.global_position.distance_to(origin_entity.global_position) <= chain_range:
				candidates.append(e)
	# Sort by distance using a temporary origin stored on self
	self._chain_origin = origin_entity
	var cmp = Callable(self, "_compare_by_distance")
	candidates.sort_custom(cmp)
	self._chain_origin = null
	var count : int = min(chain_count, candidates.size())
	for i in range(count):
		var t = candidates[i]
		if t and t.has_method("apply_status"):
			t.apply_status("shock")

func _compare_by_distance(a, b):
	if _chain_origin == null:
		return 0
	var da : float = a.global_position.distance_to(_chain_origin.global_position)
	var db : float = b.global_position.distance_to(_chain_origin.global_position)
	if da < db:
		return -1
	elif da > db:
		return 1
	return 0

func on_hit():
	# Apply shock to the primary hit target
	if hitbox and hitbox.affected_targets.size() > 0:
		var tgt = hitbox.affected_targets[hitbox.affected_targets.size() - 1]
		if tgt and tgt.has_method("apply_status"):
			tgt.apply_status("shock")
			_chain_shock(tgt)
	super.on_hit()
	if is_one_shot:
		destroy()