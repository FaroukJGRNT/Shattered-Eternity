extends SpellItem
class_name FireSpellItem

func _init() -> void:
	super._init()
	spell_type = SpellType.FIRE
	spell_action_class = FireSpell
	item_name = "Fire Proto Spell"
	item_description = "Shoots a lame ahh
	fireball."
