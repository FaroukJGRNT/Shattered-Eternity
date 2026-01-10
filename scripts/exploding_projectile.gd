extends Projectile

# Projectile that explodes on destroy by activating its own hitbox briefly
@export var speed := 220
@export var explosion_radius := 64
@export var explosion_life := 0.18

func _ready() -> void:
	if anim_player:
		anim_player.play()

func move(delta):
	if destroyed:
		return
	# Moves forward using local up direction
	var forward := Vector2.UP.rotated(rotation)
	global_position += forward * speed * delta

func set_premade_damage(entity : LivingEntity):
	if has_node("HitBox"):
		$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, $HitBox.atk_type)

func destroy():
	if destroyed:
		return
	destroyed = true
	# If this node has a HitBox child, turn it into a short-lived AoE
	if has_node("HitBox"):
		$HitBox.life_duration = explosion_life
		$HitBox.start_life()
		$HitBox.activate()
	# Optionally play an explosion animation (handled by scene)
	queue_free()
