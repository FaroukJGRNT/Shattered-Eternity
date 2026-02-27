extends Node
class_name Item

enum ItemType {
	SPELL,
	BUFF,
	KEY_ITEM,
	SKILL
}

var item_type_to_string : Dictionary = {
	ItemType.SPELL : "Spell",
	ItemType.KEY_ITEM : "Key Item",
	ItemType.SKILL : "Skill",
	ItemType.BUFF : "Buff",
}

@export var type : ItemType
@export var item_name : String
@export var item_description : String
@export var item_icon : Texture2D
