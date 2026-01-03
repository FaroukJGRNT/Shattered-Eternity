extends Projectile

@export var acceleration := 7
@export var speed := 65
@export var max_speed := 270
@export var direction := 1

func set_target(_target : LivingEntity):
	pass

func move(delta):
	position.x += (speed * delta * direction)
	speed += acceleration

func set_premade_damage(entity : LivingEntity):
	$HitBox.premade_dmg = entity.deal_damage($HitBox.motion_value, $HitBox.atk_type)
