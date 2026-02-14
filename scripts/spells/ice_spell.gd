extends Spell
class_name IceSpell

func _init() -> void:
	mana_cost = 20
	is_state_blocking = true
	spell_cat = SpellCategory.LIGHT
	spell_type = SpellType.ICE
	proj_to_spawn = load("res://scenes/projectiles/ice_projectile.tscn")

func exit():
	super.exit()
