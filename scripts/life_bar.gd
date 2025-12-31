extends TextureProgressBar

func update_health_bar(dmg):
	if owner is LivingEntity:
		max_value = owner.max_life
		value = owner.life
		$DamageBar.update_bar(dmg)

func _ready() -> void:
	max_value = owner.max_life
	value = owner.life
	print("MAX HEALTH  ", max_value)
	print("HEALTH  ", value)
