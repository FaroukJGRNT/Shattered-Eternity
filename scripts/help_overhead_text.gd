extends BasicControl
class_name HelpOverHeadText

func set_help_text(text):
	$HBoxContainer/DescriptionText.text = text

func set_help_texture(texture : Texture2D):
	$HBoxContainer/Sprite2D.texture = texture
