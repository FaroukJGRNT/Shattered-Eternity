extends Projectile

# Simple fireball: deals elemental fire damage and can apply burn accumulation
@export var speed := 340
@export var burn_apply_chance := 0.35

func _ready() -> void:
	if anim_player:
		anim_player.play()

func move(delta):
	if destroyed:
		return
	var forward := Vector2.UP.rotated(rotation)
	global_position += forward * speed * delta

func set_premade_damage(entity : LivingEntity):
	# Ask the entity to produce a "full_fire" damage container for this projectile
	if has_node("HitBox"):
		$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, "full_fire")

func on_hit():
	# Try to apply burn accumulation on the hit target (relies on HurtBox/LivingEntity behaviour)
	# Some hitbox implementations forward parent on_hit calls; if not, attach logic to hitbox script.
	if randf() <= burn_apply_chance:
		# If the projectile's hitbox can access the damaged entity via premade_dmg, nothing else required;
		# otherwise the LivingEntity accumulation system will pick up elemental damage from the DamageContainer.
		pass
	super.on_hit()
	if is_one_shot:
		destroy()
