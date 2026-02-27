extends Item
class_name SpellItem

var spell_action_class
enum SpellType {
	FIRE,
	ICE,
	THUNDER,
	BUFF,
	MANA
}

var spell_type_to_string : Dictionary = {
	SpellType.FIRE : "Fire",
	SpellType.ICE : "Ice",
	SpellType.THUNDER : "Thunder",
	SpellType.BUFF : "Buff",
	SpellType.MANA : "Mana",
}

var spell_type := SpellType.MANA

func _init() -> void:
	type = ItemType.SPELL
