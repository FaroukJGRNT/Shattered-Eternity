extends SpellItem
class_name IceSpellItem

func _init() -> void:
	super._init()
	spell_type = SpellType.ICE
	spell_action_class = IceSpell
	item_name = "Ice Proto Spell"
	item_description = "Shoots a lame ahh
	ice shard."
