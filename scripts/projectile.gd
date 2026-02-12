extends Node2D
class_name Projectile

@export var is_one_shot := true
@export var is_anim_one_shot := false

@export var anim_player : AnimatedSprite2D
@export var hitbox : HitBox
@export var hurtbox : HurtBox

var target : LivingEntity

var destroyed := false

func _ready() -> void:
	# The projectile will be destroyed once its animation ends
	if is_anim_one_shot:
		anim_player.connect("animation_finished", destroy)
	# Ensure the hitbox stays always active
	if hitbox:
		hitbox.life_looping = true
		hitbox.start_life()
		hitbox.activate()
	# Activate hurtbox
	if hurtbox:
		hurtbox.activate()


func set_target(_target : LivingEntity):
	target = _target

# Describe how the projectile will move over time
func move(delta):
	pass

# Describe what happens when the projectile hits a target
# One shot means after one hit, destruction
func on_hit():
	if is_one_shot:
		destroy()

# How to destroy the projectile. Most of the time animation -> free
func destroy():
	destroyed = true
	hitbox.desactivate()
	if hurtbox:
		hurtbox.desactivate()
	# Maybe play an animation
	queue_free()

# Since projectile damage are calculated on instanciation, not on hit
func set_premade_damage(entity : LivingEntity):
	hitbox.premade_dmg = entity.deal_damage(hitbox .motion_value, hitbox .atk_type)
	hitbox.facing = entity.facing
	hitbox.premade_dmg

# Will call move, and eventually destroy if too far
func _process(delta: float) -> void:
	if destroyed:
		return
	move(delta)
	if position.distance_to(get_tree().get_first_node_in_group("Player").position) > 2000:
		queue_free()
