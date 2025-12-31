extends State
class_name EnemyState

var enemy : LivingEntity

enum OptionType {
	NONE,
	OFFENSIVE,
	RANGED_OFFENSIVE,
	DEFENSIVE
}

@export var option_type := OptionType.NONE
@export var option_cooldown : float = 0.0
var option_timer := 0.0
