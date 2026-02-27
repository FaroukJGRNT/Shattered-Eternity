extends MultipleFocusSelectionHandler
class_name BuffSection

var icon_scene : PackedScene = load("res://ui/atoms/selectable_icon_holder.tscn")
var buffes : Array[Buff]
var icons : Array[SelectableIconHolder]

var spells : PackedScene = load("res://ui/molecules/spell_equip.tscn")


# Sets up shi
func _ready() -> void:
	super._ready()
	setup_buffes(get_tree().get_first_node_in_group("Player"))
	$Panel/VBoxContainer/HBoxContainer2/Button.connect("pressed", go_to_spells)

func go_to_spells():
	ui_manager.show_modal(spells)
	queue_free()

func setup_buffes(player : Player):
	buffes = player.buff_manager.buffs.values()
	
	for child in $Panel/VBoxContainer/HBoxContainer/Panel/GridContainer.get_children():
		child.queue_free()
	
	for buff in buffes:
		var icon = icon_scene.instantiate()
		icon.texture = buff.item_icon
		$Panel/VBoxContainer/HBoxContainer/Panel/GridContainer.add_child(icon)
		icons.append(icon)

	connect_confirmation_button()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var focused = get_viewport().gui_get_focus_owner()

	var index := icons.find(focused)

	if index != -1:
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/SubHeading.text = buffes[index].item_name
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/DescriptionText.text = buffes[index].item_description
	else:
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/SubHeading.text = "Buff name"
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/DescriptionText.text = "Buff description"
