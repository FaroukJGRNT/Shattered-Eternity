extends Projectile

var fixed_pos := Vector2(0, 0)
var direction := Vector2(1, 0)
var SPEED = 1000

func _init() -> void:
	is_destructible = false
	is_one_shot = true

func set_target(_target : LivingEntity):
	super.set_target(_target)
	fixed_pos = _target.global_position
	direction = (fixed_pos - global_position).normalized()
	look_at(fixed_pos)
	rotation_degrees += 90

func move(delta):
	global_position += direction * SPEED * delta
	print("Spear velocity: ", direction * SPEED * delta)

func set_premade_damage(entity : LivingEntity):
	$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, $HitBox.atk_type)
