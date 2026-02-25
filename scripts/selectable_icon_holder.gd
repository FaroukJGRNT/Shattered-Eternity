@tool
extends Button
class_name SelectableIconHolder

@export var text_rect : TextureRect
@export var texture: Texture2D :
	set(value):
		texture = value
		if is_inside_tree():
			text_rect.texture = value

func _ready() -> void:
	text_rect.texture = texture

func chosen():
	pass
