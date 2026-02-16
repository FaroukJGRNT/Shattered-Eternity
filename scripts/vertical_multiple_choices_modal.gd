extends MultipleFocusSelectionHandler

var elem_buff : Buff
var phys_buff : Buff
var sit_buff : Buff

func setup_buffs() -> void:
	elem_buff = Toolbox.elemental_buffs[randi_range(0, len(Toolbox.elemental_buffs) -1)]
	phys_buff = Toolbox.physical_buffs[randi_range(0, len(Toolbox.physical_buffs) -1)]
	sit_buff = Toolbox.situational_buffs[randi_range(0, len(Toolbox.situational_buffs) -1)]

	$Panel/VBoxContainer/HBoxContainer/Panel.buff = elem_buff
	$Panel/VBoxContainer/HBoxContainer/Panel.setup_labels()
	$Panel/VBoxContainer/HBoxContainer/Panel2.buff = phys_buff
	$Panel/VBoxContainer/HBoxContainer/Panel2.setup_labels()
	$Panel/VBoxContainer/HBoxContainer/Panel3.buff = sit_buff
	$Panel/VBoxContainer/HBoxContainer/Panel3.setup_labels()
