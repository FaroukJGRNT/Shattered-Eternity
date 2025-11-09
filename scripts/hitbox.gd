extends Area2D
class_name HitBox

# The base power of the attack
var motion_value := 0
# The elemental type of the attack
var atk_type := ""
# The strength of the screen shake
var cam_shake_value := 0.0
# The duration of the hitstop
var hitstop_time := 0.0
# The strength of the hitstop
var hitstop_scale := 1.0
# Whether the hitbox is active or not
var active := false
# The groups targeted by the hitbox
var targeted_groups : Array[String] = []

var is_parried := false

func _init() -> void:
	monitoring = false
	# Hitboxes look for hurtboxes on layer 2
	collision_layer = 2
	# Hitboxes don't need to be in a mask 
	collision_mask = 0

func generate_damage():
	# Let the owner generate the damage based on its stats
	return owner.deal_damage(motion_value, atk_type)
