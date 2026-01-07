extends Control
class_name MultipleFocusSelectionHandler

var found_first := false
var confirm_btn : ConfirmationButton

func _ready() -> void:
	connect_confirmation_button()

func connect_confirmation_button(node: Node = null):
	if node == null:
		node = self  # par défaut, commence par ce node

	for child in node.get_children():
		if child is SelectableIconHolder and not found_first:
			child.grab_focus()
			found_first = true
		if child is ConfirmationButton:
			confirm_btn = child
			child.connect("pressed", _on_button_pressed)
		# appel récursif pour les enfants du child
		connect_confirmation_button(child)

func _on_button_pressed():
	var focused_choice = get_viewport().gui_get_focus_owner() as SelectableIconHolder
	focused_choice.chosen()
	confirm_btn.confirm()
