extends ProjectileHitBox

func _init() -> void:
	active = true
	motion_value = 25

func on_hit():
	super.on_hit()
	var player : Player = get_tree().get_first_node_in_group("Player")
	player.mana += motion_value / 4
