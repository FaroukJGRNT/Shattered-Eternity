extends SelectableIconHolder

var def_buff : Buff = load("res://scenes/endurance_buff.tscn").instantiate()

func chosen():
	print("DEF BUF GRANTED")
	var player : LivingEntity = get_tree().get_first_node_in_group("Player")
	player.buff_manager.add_new_buff(def_buff, "endurance")
