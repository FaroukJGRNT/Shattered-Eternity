extends Projectile

# Splits into several smaller projectiles on destroy
@export var speed := 280
@export var splits := 3
@export var split_scene : PackedScene = preload("res://scenes/spear_projectile.tscn")
@export var split_spread_deg := 30

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
		$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, $HitBox.atk_type)

func destroy():
	if destroyed:
		return
	destroyed = true
	# Spawn splits
	var base_angle := rotation
	var half := (splits - 1) / 2.0
	for i in range(splits):
		var angle = base_angle + deg_to_rad((i - half) * split_spread_deg)
		var inst = split_scene.instantiate()
		inst.global_position = global_position
		inst.rotation = angle
		# Try to forward premade damage reference if available
		if has_node("HitBox") and $HitBox.premade_dmg and $HitBox.premade_dmg.daddy_ref:
			inst.set_premade_damage($HitBox.premade_dmg.daddy_ref)
		get_tree().current_scene.add_child(inst)
	# Optionally play split animation
	queue_free()