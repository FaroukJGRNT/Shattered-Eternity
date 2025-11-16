extends Projectile

var fixed_pos := Vector2(0, 0)
var direction := Vector2(0, 0)
var SPEED = 300

func _init() -> void:
	is_destructible = false
	is_one_shot = true

func set_target(_target : LivingEntity):
	super.set_target()
	fixed_pos = _target.position
	direction = (fixed_pos - position).normalized()

func move(delta):
	position += direction * SPEED * delta
