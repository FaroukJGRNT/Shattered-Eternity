extends HurtBox
class_name ProjectileHurtBox

# Custom hurtbox for projectiles
# Will call on_hit on collision, and collide with terrain of specified

@onready var real_daddy : Projectile = owner
@export var collide_with_terrain := false

func _ready() -> void:
	super._ready()
	if collide_with_terrain:
		set_collision_mask_value(8, true)

func on_area_entered(area: Area2D) -> void:
	if area == null:
		return

	if area is HitBox:
		if not area.active or not _real_daddy_in_targeted_groups(real_daddy, area.targeted_groups):
			return
		if owner in area.affected_targets:
			return

		owner.on_hit()
		area.affected_targets.append(owner)

func on_body_entered(body:Node2D):
	if collide_with_terrain:
		real_daddy.on_hit()

func _real_daddy_in_targeted_groups(diddy: Node, groups: Array) -> bool:
	for g in groups:
		if diddy.is_in_group(g):
			return true
	return false

func activate():
	set_deferred("monitoring", true)
	disabled = false

func desactivate():
	set_deferred("monitoring", false)
	disabled = true
