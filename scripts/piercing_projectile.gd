extends Projectile

# Projectile that can pierce several targets before being destroyed
@export var speed := 600
@export var max_pierces := 3
var remaining_pierces := 3

func _ready() -> void:
	remaining_pierces = max_pierces
	if anim_player:
		anim_player.play()

func move(delta):
	if destroyed:
		return
	# Simple straight movement in local up direction
	var forward := Vector2.UP.rotated(rotation)
	global_position += forward * speed * delta

func set_premade_damage(entity : LivingEntity):
	if has_node("HitBox"):
		$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, $HitBox.atk_type)

func on_hit():
	# Called when the hitbox registers a hit (some hitbox implementations forward to parent)
	remaining_pierces -= 1
	if remaining_pierces <= 0:
		destroy()
