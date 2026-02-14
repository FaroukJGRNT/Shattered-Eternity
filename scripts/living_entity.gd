extends CharacterBody2D
class_name LivingEntity

var facing : int = 1

@export var anim_player: AnimatedSprite2D

@export var hurtbox : HurtBox

@export var hitboxes : Node2D

@export var state_machine : StateMachine

@export var hit_listener : HitListener

@export var buff_manager : BuffManager

@export var status_vbox: VBoxContainer


var global_speed_scale := 1.0
var dead := false

#var FreezeBar: PackedScene = preload("res://scenes/freeze_bar.tscn")
#var BurnBar: PackedScene = preload("res://scenes/burn_bar.tscn")
#var ThunderBar: PackedScene = preload("res://scenes/thunder_bar.tscn")

#var status_bars : Dictionary = {
	#"fire": BurnBar,
	#"thunder": ThunderBar,
	#"ice": FreezeBar
#}  # {"fire": ProgressBar, "ice": ProgressBar, ...}

var active_status_bars : Dictionary = {}


@export var max_life: int = 500
@export var life: int = max_life

@export var attack: int = 12
@export var defense: int = 20

var attack_multipliers : Array[float] = [] 
var defense_multipliers : Array[float] = [] 

var crit_chance := 8.0
var crit_multipliers : Array[float] = [] 

func get_attack() -> float:
	var value = attack
	for m in attack_multipliers:
		value *= m
	return value

func get_defense() -> float:
	var value = defense
	for m in defense_multipliers:
		value *= m
	return value

enum Poises {
	PLAYER,
	SMALL,
	MEDIUM,
	LARGE
}

enum Event {
	ENEMY_KILLED,
	ENEMY_GUARD_BROKEN,
	ENEMY_INTERRUPTED,
	HIT_TAKEN,
	HIT_DEALT,
	PARRY,
	ATTACK_EVADED,
	ENEMY_STUNNED
}

enum SpecialStatus {
	NONE,
	THERMAL_SCHOK,
	PLASMA_CHARGE,
	CRYO_CHARGE
}

@export var poise_type := Poises.MEDIUM

@export var fire_atk := 2.0      # % de bonus dégâts feu
@export var thunder_atk := 2.0   # % de bonus dégâts foudre
@export var ice_atk := 2.0       # % de bonus dégâts glace

@export var thunder_res := 2.0
@export var fire_res := 2.0
@export var ice_res := 2.0

var fire_attack_multipliers : Array[float] = [] 
var ice_attack_multipliers : Array[float] = [] 
var thunder_attack_multipliers : Array[float] = [] 

func get_fire_attack():
	var value = fire_atk
	for m in fire_attack_multipliers:
		value *= m
	return value

func get_ice_attack():
	var value = ice_atk
	for m in ice_attack_multipliers:
		value *= m
	return value

func get_thunder_attack():
	var value = thunder_atk
	for m in thunder_attack_multipliers:
		value *= m
	return value


func get_fire_res():
	var value = fire_res
	for m in fire_res_multipliers:
		value *= m
	return value

func get_ice_res():
	var value = ice_res
	for m in ice_res_multipliers:
		value *= m
	return value

func get_thunder_res():
	var value = thunder_res
	for m in thunder_res_multipliers:
		value *= m
	return value

var fire_res_multipliers : Array[float] = [] 
var ice_res_multipliers : Array[float] = [] 
var thunder_res_multipliers : Array[float] = [] 

var active_special_status := SpecialStatus.NONE
@export var special_status_duration := 5.0
var special_status_timer := 0.0

@export var max_mana := 100
@export var mana := 0

var mana_cons_multipliers : Array[float] = []
var mana_regen_multipliers : Array[float] = []

@export var max_posture := 100.0
@export var posture := 0.0

enum ElemMode {
	NONE,
	FIRE,
	THUNDER,
	ICE
}

var elem_mode: ElemMode = ElemMode.NONE

# --- Accumulation par élément ---
var accum = {
	"fire": 0.0,
	"thunder": 0.0,
	"ice": 0.0
}

# --- Facteur de remplissage des barres ---
var accum_factor = {
	"fire": 0.1,
	"thunder": 0.1,
	"ice": 0.1
}

@export var accum_decay_rate := 0.5  # points par seconde
@export var posture_decay_rate := 5.0  # points par seconde

# --- Cooldowns pour chaque statut (en secondes) ---
@export var burn_cooldown_time := 3.0
@export var shock_cooldown_time := 3.0
@export var freeze_cooldown_time := 3.0

@export var burn_tick_interval := 1.0   # intervalle en secondes
var burn_tick_timer := 0.0

# --- Effets des statuts ---
@export var burn_damage_per_second := 0
@export var shock_attack_reduction := 0.5  # -50%
@export var shock_defense_reduction := 0.5 # -75%
@export var freeze_speed_reduction := 0.5  # -50% vitesse
@export var status_duration := 7.0         # durée générique des statuts

# Statuts actifs : { "burn": temps_restant, ... }
var active_status_effects = {}

var pulse_timer := 0.0  # à mettre dans la classe

func _ready() -> void:
	life = max_life
	# Set collision layers and masks
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(8, true)
	if is_in_group("Player"):
		set_collision_layer_value(1, true)
	elif is_in_group("Enemy"):
		set_collision_layer_value(2, true)

func _process(delta):
	# Vider les barres d'accumulation progressivement
	if mana > max_mana:
		mana = max_mana
	posture = max(posture - (posture_decay_rate * delta), 0)
	for key in accum.keys():
		accum[key] = max(accum[key] - accum_decay_rate * delta, 0)
	if active_special_status != SpecialStatus.NONE:
		special_status_timer -= delta
		if special_status_timer <= 0:
			match active_special_status:
				SpecialStatus.THERMAL_SCHOK:
					remove_thermal_shock()
				SpecialStatus.PLASMA_CHARGE:
					remove_plasma_charge()
				SpecialStatus.CRYO_CHARGE:
					remove_cryo_charge()

	#_update_accum_bars()

	# Appliquer les statuts actifs
	var to_remove = []
	for status in active_status_effects.keys():
		active_status_effects[status] -= delta
		# Burn is the only status that works over time, other ones are just set
		if status == "burn":
			_apply_burn(delta)

		if active_status_effects[status] <= 0:
			to_remove.append(status)

	# Nettoyer les statuts expirés
	for status in to_remove:
		_remove_status(status)

	if active_status_effects.is_empty():
		anim_player.modulate = Color(1,1,1,1)
		return
		
	# --- Pulsation (effet couleur indiquant le malus de statut) avec delta ---
	pulse_timer += delta
	var t = sin(pulse_timer * 5.0) * 0.5 + 0.5  # multiplier pour ajuster la vitesse du pulse

	if active_special_status == SpecialStatus.THERMAL_SCHOK:
		anim_player.modulate = Color(0.4, 1.0, 0.9, 1) * t + Color(1,1,1,1) * (1-t)
		return
	elif active_special_status == SpecialStatus.PLASMA_CHARGE:
		anim_player.modulate = Color(0.95, 0.65, 1.0, 1) * t + Color(1,1,1,1) * (1-t)
		return
	elif active_special_status == SpecialStatus.CRYO_CHARGE:
		anim_player.modulate = Color(0.15, 0.25, 0.55, 1) * t + Color(1,1,1,1) * (1-t)

		return

	if "burn" in active_status_effects:
		anim_player.modulate = Color(1, 0.5, 0, 1) * t + Color(1,1,1,1) * (1-t)
	elif "freeze" in active_status_effects:
		anim_player.modulate = Color(0.5, 0.8, 1, 1) * t + Color(1,1,1,1) * (1-t)
	elif "shock" in active_status_effects:
		anim_player.modulate = Color(1, 1, 0, 1) * t + Color(1,1,1,1) * (1-t)

func take_damage(damage: DamageContainer) -> DamageContainer:
	propagate_event(Event.HIT_TAKEN)
	# Appliquer les résistances directement sur le DamageContainer
	damage.fire_dmg *= 1.0 - get_fire_res() / 100.0
	damage.thunder_dmg *= 1.0 - get_thunder_res() / 100.0
	damage.ice_dmg *= 1.0 - get_ice_res() / 100.0
	damage.phys_dmg *= 1.0 - get_defense() / 100.0

	if damage.is_crit:
		damage.phys_dmg *= 3
		damage.ice_dmg *= 3
		damage.thunder_dmg *= 3
		damage.fire_dmg *= 3

	# --- Accumulation d'éléments réduite ---
	if "burn" not in active_status_effects:
		accum["fire"] += damage.fire_dmg * accum_factor["fire"]
	if "shock" not in active_status_effects:
		accum["thunder"] += damage.thunder_dmg * accum_factor["thunder"]
	if "freeze" not in active_status_effects:
		accum["ice"] += damage.ice_dmg * accum_factor["ice"]

	# Vérifier si l'accumulation dépasse la résistance et déclencher un statut
	if accum["fire"] >= fire_res:
		apply_status("burn")
		accum["fire"] = 0
	if accum["thunder"] >= thunder_res:
		apply_status("shock")
		accum["thunder"] = 0
	if accum["ice"] >= ice_res:
		apply_status("freeze")
		accum["ice"] = 0

	# Total des dégâts
	damage.total_dmg = damage.fire_dmg + damage.thunder_dmg + damage.ice_dmg + damage.phys_dmg
	if damage.total_dmg < 0:
		damage.total_dmg = 0

	# Appliquer à la vie
	life -= damage.total_dmg
	if life <= 0 and not dead:
		dead = true
		life = 0

		if damage.daddy_ref:
			damage.daddy_ref.propagate_event(Event.ENEMY_KILLED)
		die()

	return damage

func deal_damage(motion_value: int, attack_type: String = "") -> DamageContainer:
	var dmg = DamageContainer.new()
	
	dmg.daddy_ref = self

	dmg.facing = facing

	# Calcul de base
	var base_power = motion_value / 10.0
	var raw_value = get_attack() * base_power

	match attack_type:
		"phys":
			if elem_mode != ElemMode.NONE:
				# 50% phys, 50% élément actif
				dmg.phys_dmg = raw_value * 0.5
				match elem_mode:
					ElemMode.FIRE:
						dmg.fire_dmg = raw_value * 0.5 * (1.0 + get_fire_attack() / 100.0)
					ElemMode.THUNDER:
						dmg.thunder_dmg = raw_value * 0.5 * (1.0 + get_thunder_attack() / 100.0)
					ElemMode.ICE:
						dmg.ice_dmg = raw_value * 0.5 * (1.0 + get_attack() / 100.0)
			else:
				# 100% physique si aucun élément actif
				dmg.phys_dmg = raw_value

		"full_fire":
			dmg.fire_dmg = raw_value * (1.0 + fire_atk / 100.0)

		"full_thunder":
			dmg.thunder_dmg = raw_value * (1.0 + thunder_atk / 100.0)

		"full_ice":
			dmg.ice_dmg = raw_value * (1.0 + ice_atk / 100.0)

		_:
			dmg.phys_dmg = raw_value

	return dmg

func die():
	pass

func apply_status(status_name: String):
	if status_name not in active_status_effects:
		active_status_effects[status_name] = status_duration
		_show_status_label(status_name)
		if status_name == "shock":
			_apply_shock()
		elif status_name == "freeze":
			_apply_freeze()
		
		if active_special_status == SpecialStatus.NONE:
			if len(active_status_effects.keys()) >= 2:
				special_status_timer = special_status_duration
				match active_status_effects.keys()[-2]:
					"shock":
						match status_name:
							"burn":
								apply_plasma_charge()
							"freeze":
								apply_cryo_charge()
					"freeze":
						match status_name:
							"shock":
								apply_cryo_charge()
							"burn":
								apply_thermal_shock()
					"burn":
						match status_name:
							"shock":
								apply_plasma_charge()
							"freeze":
								apply_thermal_shock()

func _apply_burn(delta):
	burn_damage_per_second = round(max_life * 0.02)
	burn_tick_timer += delta
	if burn_tick_timer >= burn_tick_interval:
		burn_tick_timer = 0.0
		life -= burn_damage_per_second
		hit_listener.create_label(Color.ORANGE_RED, str(int(burn_damage_per_second)), 1)

		if life <= 0:
			life = 0
			die()

func _apply_shock():
	attack_multipliers.append(shock_attack_reduction)
	defense_multipliers.append(shock_defense_reduction)

func _apply_freeze():
	anim_player.speed_scale = freeze_speed_reduction
	global_speed_scale *= 0.75

@export var thermal_shock_fire_reduction := 0.5
@export var thermal_shock_ice_reduction := 0.5
@export var thermal_shock_thunder_reduction := 0.5

func apply_thermal_shock():
	fire_res_multipliers.append(thermal_shock_fire_reduction)
	ice_res_multipliers.append(thermal_shock_ice_reduction)
	thunder_res_multipliers.append(thermal_shock_thunder_reduction)
	active_special_status = SpecialStatus.THERMAL_SCHOK
	_show_status_label("thermal_shock")

func remove_thermal_shock():
	fire_res_multipliers.erase(thermal_shock_fire_reduction)
	ice_res_multipliers.erase(thermal_shock_ice_reduction)
	thunder_res_multipliers.erase(thermal_shock_thunder_reduction)
	active_special_status = SpecialStatus.NONE

func apply_plasma_charge():
	active_special_status = SpecialStatus.PLASMA_CHARGE
	_show_status_label("plasma_charge")

func remove_plasma_charge():
	active_special_status = SpecialStatus.NONE

func apply_cryo_charge():
	active_special_status = SpecialStatus.CRYO_CHARGE
	_show_status_label("cryo_charge")

func remove_cryo_charge():
	active_special_status = SpecialStatus.NONE


func _remove_status(status_name: String):
	match status_name:
		"burn":
			burn_tick_timer = 0.0
		"shock":
			attack_multipliers.erase(shock_attack_reduction)
			defense_multipliers.erase(shock_defense_reduction)
		"freeze":
			global_speed_scale = 1.0
			if anim_player:
				anim_player.speed_multipliers.append(freeze_speed_reduction)
	active_status_effects.erase(status_name)

func _show_status_label(status_name: String):
	match status_name:
		"burn":
			hit_listener.create_label(Color.ORANGE_RED, "BURNED!", 1.3)
		"shock":
			hit_listener.create_label(Color.YELLOW, "SHOCKED!", 1.3)
		"freeze":
			hit_listener.create_label(Color.DEEP_SKY_BLUE, "FREEZED!", 1.3)
		"thermal_shock":
			hit_listener.create_label(Color.MEDIUM_SPRING_GREEN, "THERMAL SHOCK!", 1.4, 70)
		"plasma_charge":
			hit_listener.create_label(Color.WEB_PURPLE, "PLASMA CHARGE!", 1.4, 70)
		"cryo_charge":
			hit_listener.create_label(Color.MIDNIGHT_BLUE, "CRYO CHARGE!", 1.4, 70)
#func _update_accum_bars():
	#var index := 0
	#for elem in accum.keys():
		#var value = accum[elem]
#
		#if value > 0:
			## Créer la barre si elle n'existe pas encore
			#if not active_status_bars.has(elem):
				#var bar = status_bars[elem].instantiate()
				#add_child(bar)
				#active_status_bars[elem] = bar
#
			## Mettre à jour la barre
			#var bar_node = active_status_bars[elem]
			#bar_node.value = accum[elem]
			#match elem:
				#"fire":
					#bar_node.max_value = fire_res
				#"ice":
					#bar_node.max_value = ice_res
				#"thunder":
					#bar_node.max_value = thunder_res
#
			## Positionner la barre comme dans un VBox
			#bar_node.position = Vector2(-20, -40 - index * 8)  # -40 au-dessus du perso, puis -12px par barre
			#index += 1
#
		#else:
			## Si la valeur est 0 et la barre existe → on la supprime
			#if active_status_bars.has(elem):
				#active_status_bars[elem].queue_free()
				#active_status_bars.erase(elem)

func get_stunned(vel_x : float, duration : float, perpretator):
	if perpretator is LivingEntity:
		perpretator.propagate_event(Event.ENEMY_STUNNED, self)

func get_staggered(vel_x : float = 0.0):
	pass

func get_state():
	return state_machine.get_current_state().name.to_lower()
	
func change_state(new_state):
	state_machine.on_state_transition(new_state)

func propagate_event(event : Event, additional : Variant = null):
	if buff_manager:
		buff_manager.propagate_event(event)
