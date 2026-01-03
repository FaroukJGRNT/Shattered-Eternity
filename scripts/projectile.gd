extends Node2D
class_name Projectile

@export var is_destructible := false
@export var is_one_shot := true
@export var is_anim_one_shot := false

@export var hitbox : HitBox
@export var hurtbox : HurtBox

#@export var hitbox_active_frames : Array[int]

@export var anim_player : AnimatedSprite2D

var target : LivingEntity

var destroyed := false

func _ready() -> void:
	#if hitbox_active_frames == [-1]:
		#hitbox.activate()
	if is_anim_one_shot:
		anim_player.connect("animation_finished", destroy)
	if hitbox:
		hitbox.life_looping = true
		hitbox.start_life()
		hitbox.activate()
	if hurtbox:
		hurtbox.activate()


func set_target(_target : LivingEntity):
	target = _target

func move(delta):
	pass

func on_hit():
	if is_one_shot:
		destroy()

func destroy():
	destroyed = true
	hitbox.desactivate()
	if hurtbox:
		hurtbox.activate()

	# Maybe play an animation
	queue_free()

func set_premade_damage(entity : LivingEntity):
	pass

func _process(delta: float) -> void:
	if destroyed:
		return
	move(delta)
	if position.distance_to(get_tree().get_first_node_in_group("Player").position) > 2000:
		queue_free()
