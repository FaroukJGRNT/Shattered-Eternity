extends SimpleInfoModal

@export var item : Item

func setup_labels():
	$Panel/VBoxContainer/VBoxContainer2/SubHeading.text = item.item_name
	$Panel/VBoxContainer/VBoxContainer2/DescriptionText.text = item.item_type_to_string[item.type]
	$Panel/VBoxContainer/VBoxContainer2/DescriptionText2.text = item.item_description
