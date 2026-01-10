extends CharacterBody2D
class_name LivingEntity

var facing : int = 1

@export var anim_player: AnimatedSprite2D

@export var hurtbox : HurtBox

@export var hitboxes : Node2D

@export var state_machine : Node

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

@export var max_life: int = 0
@export var life: int = 0
@export var attack: int = 0
@export var defense: int = 0

enum Poises {
	PLAYER,
	SMALL,
	MEDIUM,
	LARGE
}

enum Event {
	ENEMY_KILLED,
	HIT_TAKEN,
	PARRY
}

var poise_type := Poises.MEDIUM

@export var fire_atk := 0.0      # % de bonus dégâts feu
@export var thunder_atk := 0.0   # % de bonus dégâts foudre
@export var ice_atk := 0.0       # % de bonus dégâts glace

@export var thunder_res := 0.0
@export var fire_res := 0.0
@export var ice_res := 0.0

@export var max_mana := 0
@export var mana := 0

@export var max_posture := 100
@export var posture := 0

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

# --- Cooldowns pour chaque statut (en secondes) ---
@export var burn_cooldown_time := 3.0
@export var shock_cooldown_time := 3.0
@export var freeze_cooldown_time := 3.0

@export var burn_tick_interval := 1.0   # intervalle en secondes
var burn_tick_timer := 0.0

# --- Effets des statuts ---
@export var burn_damage_per_second := 0
@export var shock_attack_reduction := 0.5  # -50%
@export var shock_defense_reduction := 0.75 # -75%
@export var freeze_speed_reduction := 0.5  # -50% vitesse
@export var status_duration := 7.0         # durée générique des statuts

# Statuts actifs : { "burn": temps_restant, ... }
var active_status_effects = {}

# --- Labels spécifiques pour chaque statut ---
#var frozen_label : PackedScene = preload("res://scenes/frozen_text.tscn") 
#var burn_label : PackedScene = preload("res://scenes/burn_text.tscn") 
#var elec_label : PackedScene = preload("res://scenes/elec_text.tscn") 
#var damage_label : PackedScene = preload("res://scenes/damage_text.tscn") 

var pulse_timer := 0.0  # à mettre dans la classe

func _process(delta):
	# Because max life is dynamic...
	burn_damage_per_second = round(max_life * 0.02)
	# Vider les barres d'accumulation progressivement
	#posture = max(posture - (accum_decay_rate/5 * delta), 0)
	for key in accum.keys():
		accum[key] = max(accum[key] - accum_decay_rate * delta, 0)
	#_update_accum_bars()

	# Appliquer les statuts actifs
	var to_remove = []
	for status in active_status_effects.keys():
		active_status_effects[status] -= delta
		# Burn is the only status that works over time, other ones are just set
		if status == "burn":
			_apply_burn(delta)
		#elif status == "shock":
			#_apply_shock()
		#elif status == "freeze":
			#_apply_freeze()
		
		if active_status_effects[status] <= 0:
			to_remove.append(status)
	
	# Nettoyer les statuts expirés
	for status in to_remove:
		_remove_status(status)

	# --- Pulsation (effet couleur indiquant le malus de statut) avec delta ---
	pulse_timer += delta
	var t = sin(pulse_timer * 5.0) * 0.5 + 0.5  # multiplier pour ajuster la vitesse du pulse

	if "burn" in active_status_effects:
		anim_player.modulate = Color(1, 0.5, 0, 1) * t + Color(1,1,1,1) * (1-t)
	elif "freeze" in active_status_effects:
		anim_player.modulate = Color(0.5, 0.8, 1, 1) * t + Color(1,1,1,1) * (1-t)
	elif "shock" in active_status_effects:
		anim_player.modulate = Color(1, 1, 0, 1) * t + Color(1,1,1,1) * (1-t)
	else:
		anim_player.modulate = Color(1,1,1,1)

func take_damage(damage: DamageContainer) -> DamageContainer:
	propagate_event(Event.HIT_TAKEN)
	# Appliquer les résistances directement sur le DamageContainer
	damage.fire_dmg *= round(1.0 - fire_res / 100.0)
	damage.thunder_dmg *= round(1.0 - thunder_res / 100.0)
	damage.ice_dmg *= round(1.0 - ice_res / 100.0)
	damage.phys_dmg *= round(1.0 - defense / 100.0)
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

	if posture >= max_posture:
		posture = 0
		if poise_type != Poises.PLAYER:
			hit_listener.create_label(Color.REBECCA_PURPLE, "STAGGERED!", 1.3)
			get_staggered()

	# Total des dégâts
	damage.total_dmg = damage.fire_dmg + damage.thunder_dmg + damage.ice_dmg + damage.phys_dmg
	if damage.total_dmg < 0:
		damage.total_dmg = 0

	# Appliquer à la vie
	life -= damage.total_dmg
	if life <= 0 and not dead:
		dead = true
		life = 0
		damage.daddy_ref.propagate_event(Event.ENEMY_KILLED)
		die()
		

	return damage

func deal_damage(motion_value: int, attack_type: String = "") -> DamageContainer:
	var dmg = DamageContainer.new()
	
	dmg.daddy_ref = self

	dmg.facing = facing

	# Calcul de base
	var base_power = motion_value / 10.0
	var raw_value = attack * base_power

	match attack_type:
		"phys":
			if elem_mode != ElemMode.NONE:
				# 50% phys, 50% élément actif
				dmg.phys_dmg = raw_value * 0.5
				match elem_mode:
					ElemMode.FIRE:
						dmg.fire_dmg = raw_value * 0.5 * (1.0 + fire_atk / 100.0)
					ElemMode.THUNDER:
						dmg.thunder_dmg = raw_value * 0.5 * (1.0 + thunder_atk / 100.0)
					ElemMode.ICE:
						dmg.ice_dmg = raw_value * 0.5 * (1.0 + ice_atk / 100.0)
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

func _apply_burn(delta):
	burn_tick_timer += delta
	if burn_tick_timer >= burn_tick_interval:
		burn_tick_timer = 0.0
		life -= burn_damage_per_second
		#var dmg_text_instance = damage_label.instantiate()
		#dmg_text_instance.position = owner.position
		#dmg_text_instance.position.y -= 20
		#dmg_text_instance.add_theme_color_override("font_color", Color.ORANGE)
		#dmg_text_instance.text = str(int(burn_damage_per_second))  # affiche la valeur
		#add_child(dmg_text_instance)
		hit_listener.create_label(Color.ORANGE_RED, str(int(burn_damage_per_second)), 1)

		if life <= 0:
			life = 0
			Engine.time_scale = 1.0
			die()

func _apply_shock():
	attack *= round(1.0 - shock_attack_reduction)
	defense *= round(1.0 - shock_defense_reduction)

func _apply_freeze():
	anim_player.speed_scale = freeze_speed_reduction
	global_speed_scale *= 0.75

func _remove_status(status_name: String):
	match status_name:
		"burn":
			burn_tick_timer = 0.0
		"shock":
			attack *= 2 
			defense *= 2
		"freeze":
			global_speed_scale = 1.0
			if anim_player:
				anim_player.speed_scale = 1.0  # remettre normal
	active_status_effects.erase(status_name)

func _show_status_label(status_name: String):
	var label: Node = null
	match status_name:
		"burn":
			hit_listener.create_label(Color.ORANGE_RED, "BURNED!", 1.3)
		"shock":
			hit_listener.create_label(Color.YELLOW, "SHOCKED!", 1.3)
		"freeze":
			hit_listener.create_label(Color.DEEP_SKY_BLUE, "FREEZED!", 1.3)
	if label:
		label.position = Vector2(0, -40) # un peu au-dessus du perso
		add_child(label)

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

func get_stunned(vel_x : float, duration : float):
	pass

func get_staggered():
	pass

func get_state():
	pass
	
func propagate_event(event : Event):
	$BuffManager.propagate_event(event)
