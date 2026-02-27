extends InteractibleLevelObject
class_name MerchantItem

@export var item : Item
@export var price := 2500

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		$HelpOverheadText.fade_in()
		$Panel.fade_in()
		player_ref = body
		active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		$HelpOverheadText.fade_out()
		$Panel.fade_out()
		active = false


func  _ready() -> void:
	var available_items = Toolbox.elemental_buffs + Toolbox.physical_buffs + Toolbox.situational_buffs
	item = available_items[randi_range(0, len(available_items) - 1)]

	$Sprite2D.texture = item.item_icon
	$Label.text = str(price)
	
	$Panel/VBoxContainer/SubHeading.text = item.item_name
	$Panel/VBoxContainer/SubHeading2.text = item.item_type_to_string[item.type]
	$Panel/VBoxContainer/DescriptionText.text = item.item_description

func interact():
	if player_ref.mana_echoes >= price:
		player_ref.mana_echoes -= price
		player_ref.give_item(item, true)
		queue_free()
