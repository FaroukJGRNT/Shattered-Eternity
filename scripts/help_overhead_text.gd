extends BasicControl
class_name HelpOverHeadText

@export var the_text : String = ""

func _ready() -> void:
	super._ready()
	if the_text != "":
		$HBoxContainer/DescriptionText.text = the_text

func set_help_text(text):
	$HBoxContainer/DescriptionText.text = text

func set_help_texture(texture : Texture2D):
	$HBoxContainer/Sprite2D.texture = texture
