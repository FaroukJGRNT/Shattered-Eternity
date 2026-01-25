extends EnemyAttackState

var proj : PackedScene = load("res://scenes/spirit_spit.tscn")

var has_shot : bool = false

func enter():
	super.enter()
	has_shot = false

func update(delta):
	super.update(delta)
	if AnimPlayer.frame >= 7 and not has_shot:
		has_shot = true
		var spit : SpiritSpit = proj.instantiate()
		spit.position = owner.global_position
		spit.facing =  owner.facing
		spit.set_premade_damage(owner)
		spit.HORIZ_VELOCITY = max(abs(enemy.position.x - enemy.target.position.x) * 1.6, 30)
		get_tree().get_first_node_in_group("Level").add_child(spit)
