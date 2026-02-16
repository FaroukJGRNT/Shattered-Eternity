extends Control
class_name SimpleInfoModal

var confirm_btn : ConfirmationButton

func _ready() -> void:
	connect_confirmation_button()

func connect_confirmation_button(node: Node = null):
	if node == null:
		node = self  # par défaut, commence par ce node

	for child in node.get_children():
		if child is ConfirmationButton:
			confirm_btn = child
			child.connect("pressed", _on_button_pressed)
		# appel récursif pour les enfants du child
		connect_confirmation_button(child)

func _on_button_pressed():
	confirm_btn.confirm()
