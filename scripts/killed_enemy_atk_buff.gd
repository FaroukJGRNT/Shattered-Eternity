extends Buff
class_name KilledEnemyAtkBuff

var bonus := 1.2

func _init() -> void:
	buff_type = BuffType.SITUATIONAL
	item_name = "Murder Boner"
	item_description = "Increases physical attack by 20% when an enemy is killed"
	timeout = 7.0
	trigger_event = LivingEntity.Event.ENEMY_KILLED
 
func activate(additional : Variant = null):
	daddy.attack_multipliers.append(bonus)

func desactivate():
	daddy.attack_multipliers.erase(bonus)
