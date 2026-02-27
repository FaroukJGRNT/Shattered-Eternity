extends FocusableChoice

var spell : SpellItem

@export var desription : Label
@export var icon_holder : Button

func setup_labels():
	desription.text = spell.spell_type_to_string[spell.spell_type]
	icon_holder.texture = spell.item_icon
