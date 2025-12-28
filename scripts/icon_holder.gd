@tool
extends Panel

@export var texture: Texture2D :
	set(value):
		texture = value
		if is_inside_tree():
			$TextureRect.texture = value

func _ready() -> void:
	$TextureRect.texture = texture
