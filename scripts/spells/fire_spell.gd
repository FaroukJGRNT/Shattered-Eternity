extends Spell
class_name FireSpell

func _init() -> void:
	mana_cost = 20
	is_state_blocking = true
	spell_cat = SpellCategory.LIGHT
	spell_type = SpellType.FIRE
	proj_to_spawn = load("res://scenes/projectiles/fire_spell_projectile.tscn")

func exit():
	super.exit()
