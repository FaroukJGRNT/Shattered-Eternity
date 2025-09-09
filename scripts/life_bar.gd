extends TextureProgressBar

func update_health_bar(dmg):
	if owner is LivingEntity:
		max_value = owner.max_life
		value = owner.life
		$DamageBar.update_bar(dmg)

func _ready() -> void:
	update_health_bar(0)
