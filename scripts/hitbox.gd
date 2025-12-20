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
# The direction of the hit
var facing := 1
# Can the hitbox inflict stun
var can_stun := false

var push_back := 0

var is_guard_break := false
var is_phys_atk := true

# For projectiles, since you cant generate damage from them, they're detached
# from their owmer
var premade_dmg : DamageContainer = null

func _init() -> void:
	desactivate()
	# Hitboxes look for hurtboxes on layer 2
	collision_layer = 2
	# Hitboxes don't need to be in a mask 
	collision_mask = 0

func generate_damage() -> DamageContainer:
	if premade_dmg != null:
		print("returned premade")
		print(premade_dmg.phys_dmg, premade_dmg.total_dmg)
		return premade_dmg
	# Let the owner generate the damage based on its stats
	return owner.deal_damage(motion_value, atk_type)

func activate():
	set_deferred("monitoring", true)
	active = true

func desactivate():
	set_deferred("monitoring", false)
	active = false

# Is called whenever the hitbox deals damage to a hurtbox
func on_hit():
	pass
