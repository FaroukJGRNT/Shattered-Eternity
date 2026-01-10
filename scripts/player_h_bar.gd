extends TextureProgressBar

func update_health_bar(dmg):
	var player : Player = get_tree().get_first_node_in_group("Player")
	max_value = player.max_life
	value = player.life
	$RealLifeBar.max_value = player.max_life
	$RealLifeBar.value = player.life
	$DamageBar.update_bar(dmg)

func _ready() -> void:
	max_value = 100 
	value = 100
	$RealLifeBar.max_value = max_value
	$RealLifeBar.value = value
