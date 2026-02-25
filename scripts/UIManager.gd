extends Node
class_name UIManager

# Racine pour toutes les fenêtres/modals
@onready var canvas_root := get_tree().get_first_node_in_group("UI") # ou crée un Control parent

func _ready():
	if not canvas_root:
		# Crée un Control racine pour l'UI
		canvas_root = Control.new()
		canvas_root.name = "UIRoot"
		get_tree().root.add_child.call_deferred(canvas_root)

# Fonction pour afficher un modal
func show_modal(modal_scene: PackedScene) -> Node:
	canvas_root = get_tree().get_first_node_in_group("UI")
	var modal = modal_scene.instantiate()
	canvas_root.add_child(modal)
	modal.set_z_index(1000) # Toujours devant
	return modal

# Fonction pour retirer un modal
func hide_modal(modal: Node) -> void:
	if modal and modal.get_parent() == canvas_root:
		modal.queue_free()
