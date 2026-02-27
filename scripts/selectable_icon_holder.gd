@tool
extends Button
class_name SelectableIconHolder

signal chosen_fr
@export var text_rect : TextureRect
@export var texture: Texture2D :
	set(value):
		texture = value
		if is_inside_tree():
			text_rect.texture = value

func _ready() -> void:
	text_rect.texture = texture
	connect("pressed", chosen_fr.emit)

func _process(delta: float) -> void:
	if has_focus() and Input.is_action_just_pressed("accept"):
		chosen_fr.emit()

func chosen():
	pass

func actually_chosen():
	pass
