extends Area2D
class_name HitBox

@export var test := false
# The base power of the attack
@export var motion_value := 0
# The elemental type of the attack
@export var atk_type := ""

enum Impact {
	LIGHT,
	NORMAL,
	BIG,
	HUGE
}

var active := false
# The groups targeted by the hitbox
var targeted_groups : Array[String] = []
# The direction of the hit
var facing := 1
# Does the hit go is all directions ?
@export var multidirectional := false

var affected_targets : Array[LivingEntity]
@export var life_duration := 1.0
var timer := 0.0
@export var life_looping := false
var life_used := false

enum Pushback {
	NORMAL,
	STRONG
}

enum AttackType {
	SLASH,
	THRUST,
	BONK,
	NONE
}

@export var push_back : Pushback = Pushback.NORMAL
@export var attack_type : AttackType = AttackType.SLASH
@export var impact : Impact = Impact.NORMAL

@export var is_guard_break := false
@export var is_phys_atk := true

# For projectiles, since you cant generate damage from them, they're detached
# from their owmer
var premade_dmg : DamageContainer = null

func _ready() -> void:
	var bad_guys = ["Enemy", "EnemyProjectile"]
	var good_guys = ["Player", "AllyProjectile"]
	# Decide your positionment based on your father nature
	collision_layer = 0
	collision_mask = 0
	if owner.is_in_group("Player") or owner.is_in_group("AllyProjectile"):
		targeted_groups = bad_guys
		set_collision_layer_value(1, true)
	elif owner.is_in_group("Enemy") or owner.is_in_group("EnemyProjectile"):
		targeted_groups = good_guys
		set_collision_layer_value(2, true)
	desactivate()

func generate_damage() -> DamageContainer:
	if premade_dmg != null:
		return premade_dmg
	# Let the owner generate the damage based on its stats
	return owner.deal_damage(motion_value, atk_type)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		end_life()

func start_life():
	life_used = false
	affected_targets = []
	timer = life_duration

func end_life():
	affected_targets = []
	if life_looping:
		start_life()

func activate():
	set_deferred("monitoring", true)
	active = true

func desactivate():
	set_deferred("monitoring", false)
	active = false

# Is called whenever the hitbox deals damage to a hurtbox
func on_hit():
	pass
