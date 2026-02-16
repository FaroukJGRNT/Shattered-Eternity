extends Node
class_name  Item

enum ItemType {
	SPELL,
	KEY_ITEM,
	SKILL
}

var item_type_to_string : Dictionary = {
	ItemType.SPELL : "Spell",
	ItemType.KEY_ITEM : "Key Item",
	ItemType.SKILL : "Skill",
}

@export var type : ItemType
@export var item_name : String
@export var item_description : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
