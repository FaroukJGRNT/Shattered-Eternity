extends FocusableChoice

var buff : Buff

@export var subheading : Label
@export var desription : Label

func chosen():
	var player : Player = get_tree().get_first_node_in_group("Player")
	player.buff_manager.add_new_buff(buff, buff.buff_name)
	if buff.is_one_shot:
		player.buff_manager.apply_one_shot_buff(buff)

func setup_labels():
	subheading.text = buff.buff_name
	desription.text = buff.buff_description
