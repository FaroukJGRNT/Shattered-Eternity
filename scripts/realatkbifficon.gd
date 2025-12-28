extends SelectableIconHolder

var atk_buff : Buff = load("res://scenes/revenge_buff.tscn").instantiate()

func chosen():
	print("ATK BUF GRANTED")
	var player : LivingEntity = get_tree().get_first_node_in_group("Player")
	player.buff_manager.add_new_buff(atk_buff, "revenge")
