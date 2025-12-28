@tool
extends Button
class_name SelectableIconHolder

@export var texture: Texture2D :
	set(value):
		texture = value
		if is_inside_tree():
			$TextureRect.texture = value

func _ready() -> void:
	$TextureRect.texture = texture

func chosen():
	pass
