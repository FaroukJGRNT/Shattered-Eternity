extends FocusableChoice

var buff : Buff

@export var subheading : Label
@export var desription : Label
@export var icon_holder : Panel

func chosen():
	var player : Player = get_tree().get_first_node_in_group("Player")
	player.give_item(buff, true)

func setup_labels():
	subheading.text = buff.item_name
	desription.text = buff.item_description
	icon_holder.texture = buff.item_icon
