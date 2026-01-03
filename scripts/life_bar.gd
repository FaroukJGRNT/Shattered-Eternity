extends TextureProgressBar

func update_health_bar(dmg):
	if owner is LivingEntity:
		$TextureProgressBar.max_value = owner.max_life
		$TextureProgressBar.value = owner.life
		$DamageBar.update_bar(dmg)

func _ready() -> void:
	max_value = owner.max_life
	value = owner.life
	$TextureProgressBar.max_value = max_value
	$TextureProgressBar.value = value
