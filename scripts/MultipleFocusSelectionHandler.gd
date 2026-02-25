extends Control
class_name MultipleFocusSelectionHandler

var found_first := false
var confirm_btn : ConfirmationButton

# Sets up shi
func _ready() -> void:
	connect_confirmation_button()

# Connects the confirm btn and finds the first focusaable item
func connect_confirmation_button(node: Node = null):
	if node == null:
		node = self  # par défaut, commence par ce node

	for child in node.get_children():
		if child is FocusableChoice or child is SelectableIconHolder and not found_first:
			print("Found first selec")
			print(child)
			print(child.name)
			child.grab_click_focus()
			found_first = true
		if child is ConfirmationButton:
			confirm_btn = child
			child.connect("pressed", _on_button_pressed)
		# appel récursif pour les enfants du child
		connect_confirmation_button(child)

# What to do when the confirm btn is pressed
func _on_button_pressed():
	var focused_choice = get_viewport().gui_get_focus_owner()
	focused_choice.chosen()
	confirm_btn.confirm()
