extends MultipleFocusSelectionHandler

var player_ref : Player
var available_spells : Array[SpellItem] = []
var icons : Array[SelectableIconHolder] = []

var buffs : PackedScene = load("res://ui/molecules/buffs_section.tscn")
var icon_scene : PackedScene = load("res://ui/atoms/selectable_icon_holder.tscn")

enum Mode {
	SELCT_SLOT,
	SELECT_SPELL1,
	SELECT_SPELL2
} 

var mode := Mode.SELCT_SLOT

# Sets up shi
func _ready() -> void:
	super._ready()
	# Connect the switch
	$Panel/VBoxContainer/HBoxContainer2/Button.connect("pressed", go_to_buffs)
	# Recup available spells
	player_ref = get_tree().get_first_node_in_group("Player")
	available_spells = player_ref.spells
	
	# Set up slots
	if player_ref.equipped_spell1:
		$Panel/VBoxContainer/HBoxContainer/Slot1.spell = player_ref.equipped_spell1.item_ref
		$Panel/VBoxContainer/HBoxContainer/Slot1.setup_labels()
	$Panel/VBoxContainer/HBoxContainer/Slot1/SelectableIconHolder.connect("chosen_fr", switch_to_selection1)

	if player_ref.equipped_spell2:
		$Panel/VBoxContainer/HBoxContainer/Slot2.spell = player_ref.equipped_spell2.item_ref
		$Panel/VBoxContainer/HBoxContainer/Slot2.setup_labels()
	$Panel/VBoxContainer/HBoxContainer/Slot2/SelectableIconHolder.connect("chosen_fr", switch_to_selection2)

	# Set up the spell list section
	for child in $Panel/VBoxContainer/Panel/GridContainer.get_children():
		child.queue_free()
		icons.clear()

	for spell in available_spells:
		var icon = icon_scene.instantiate()
		icon.texture = spell.item_icon
		$Panel/VBoxContainer/Panel/GridContainer.add_child(icon)
		icons.append(icon)
		icon.connect("chosen_fr", spell_chosen)
		icon.disabled = true

func spell_chosen():
	var focused_choice = get_viewport().gui_get_focus_owner()
	if focused_choice is SelectableIconHolder:
		var spell : SpellItem = available_spells[icons.find(focused_choice)]
		if spell:
			if mode == Mode.SELECT_SPELL1:
				player_ref.equip_spell_slot1(spell)
			if mode == Mode.SELECT_SPELL2:
				player_ref.equip_spell_slot2(spell)

			mode = Mode.SELCT_SLOT
			# disable avail icons
			for icon in icons:
				icon.disabled = true
			# able the slots
			$Panel/VBoxContainer/HBoxContainer/Slot1/SelectableIconHolder.disabled = false
			$Panel/VBoxContainer/HBoxContainer/Slot2/SelectableIconHolder.disabled = false

			# Set up slots
			if player_ref.equipped_spell1:
				$Panel/VBoxContainer/HBoxContainer/Slot1.spell = player_ref.equipped_spell1.item_ref
				$Panel/VBoxContainer/HBoxContainer/Slot1.setup_labels()
			if player_ref.equipped_spell2:
				$Panel/VBoxContainer/HBoxContainer/Slot2.spell = player_ref.equipped_spell2.item_ref
				$Panel/VBoxContainer/HBoxContainer/Slot2.setup_labels()
			# Give focus
			$Panel/VBoxContainer/HBoxContainer/Slot1/SelectableIconHolder.grab_click_focus()

func switch_to_selection1():
	# The slots can't focus anymore
	$Panel/VBoxContainer/HBoxContainer/Slot1/SelectableIconHolder.disabled = true
	$Panel/VBoxContainer/HBoxContainer/Slot2/SelectableIconHolder.disabled = true
	
	# Able focus for the selectable spells
	for icon in icons:
		icon.disabled = false
	if len(icons) >= 1:
		icons[0].grab_click_focus()

	mode = Mode.SELECT_SPELL1

func switch_to_selection2():
	# The slots can't focus anymore
	$Panel/VBoxContainer/HBoxContainer/Slot1/SelectableIconHolder.disabled = true
	$Panel/VBoxContainer/HBoxContainer/Slot2/SelectableIconHolder.disabled = true
	
	# Able focus for the selectable spells
	for icon in icons:
		icon.disabled = false
	if len(icons) >= 1:
		icons[0].grab_click_focus()

	mode = Mode.SELECT_SPELL2

func go_to_buffs():
	ui_manager.show_modal(buffs)
	queue_free()

func _process(delta: float) -> void:
	# Show dynamically the focused spell
	var focused_choice = get_viewport().gui_get_focus_owner()
	if focused_choice is SelectableIconHolder:
		if focused_choice == $Panel/VBoxContainer/HBoxContainer/Slot1/SelectableIconHolder:
			var spell = player_ref.equipped_spell1
			if spell:
				$Panel/VBoxContainer/HBoxContainer/VBoxContainer3/SubHeading.text = spell.item_name
				$Panel/VBoxContainer/HBoxContainer/VBoxContainer3/DescriptionText.text = spell.item_description
		elif focused_choice == $Panel/VBoxContainer/HBoxContainer/Slot2/SelectableIconHolder:
			var spell = player_ref.equipped_spell2
			if spell:
				$Panel/VBoxContainer/HBoxContainer/VBoxContainer3/SubHeading.text = spell.item_name
				$Panel/VBoxContainer/HBoxContainer/VBoxContainer3/DescriptionText.text = spell.item_description
		else:
			var spell : SpellItem = available_spells[icons.find(focused_choice)]
			if spell:
				$Panel/VBoxContainer/HBoxContainer/VBoxContainer3/SubHeading.text = spell.item_name
				$Panel/VBoxContainer/HBoxContainer/VBoxContainer3/DescriptionText.text = spell.item_description
