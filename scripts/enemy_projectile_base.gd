extends Projectile
class_name EnemyProjectile

@export var hitbox : ProjectileHitBox
@export var hurtbox : ProjectileHurtBox

func _ready() -> void:
	super._ready()
	
