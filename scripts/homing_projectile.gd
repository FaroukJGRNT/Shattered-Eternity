extends Projectile

# Homing projectile that steers toward its target
@export var speed := 300
@export var turn_rate := 6.0
var direction := Vector2(1, 0)

func _ready() -> void:
	if anim_player:
		anim_player.play()

func set_target(_target : LivingEntity):
	super.set_target(_target)
	if target:
		direction = (target.global_position - global_position).normalized()
		look_at(target.global_position)
		rotation_degrees += 90

func move(delta):
	if destroyed:
		return
	if target:
		var desired := (target.global_position - global_position).normalized()
		# Rotate the current direction toward the desired one limited by turn_rate
		var ang_diff := wrapf(desired.angle() - direction.angle(), -PI, PI)
		var max_rot := turn_rate * delta
		ang_diff = clamp(ang_diff, -max_rot, max_rot)
		direction = direction.rotated(ang_diff).normalized()
		rotation_degrees = direction.angle() * 180.0 / PI + 90
	global_position += direction * speed * delta

func set_premade_damage(entity : LivingEntity):
	if has_node("HitBox"):
		$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, $HitBox.atk_type)

func on_hit():
	# default: destroy on first hit
	super.on_hit()
	if is_one_shot:
		destroy()
