extends SpellItem
class_name ThunderSpellItem

func _init() -> void:
	super._init()
	spell_type = SpellType.THUNDER
	spell_action_class = ThunderSpell
	item_name = "Thunder Proto Spell"
	item_description = "Shoots a lame ahh
	thunderbolt."
