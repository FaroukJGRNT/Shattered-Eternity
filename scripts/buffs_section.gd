extends MultipleFocusSelectionHandler
class_name BuffSection

var icon_scene : PackedScene = load("res://ui/atoms/selectable_icon_holder.tscn")
var buffes : Array[Buff]
var icons : Array[SelectableIconHolder]

func setup_buffes(player : Player):
	buffes = player.buff_manager.buffs.values()
	
	for child in $Panel/VBoxContainer/HBoxContainer/Panel/GridContainer.get_children():
		child.queue_free()
	
	for buff in buffes:
		var icon = icon_scene.instantiate()
		icon.texture = buff.buff_icon
		$Panel/VBoxContainer/HBoxContainer/Panel/GridContainer.add_child(icon)
		icons.append(icon)

	connect_confirmation_button()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var focused = get_viewport().gui_get_focus_owner()

	var index := icons.find(focused)

	if index != -1:
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/SubHeading.text = buffes[index].buff_name
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/DescriptionText.text = buffes[index].buff_description
	else:
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/SubHeading.text = "Buff name"
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer/DescriptionText.text = "Buff description"
