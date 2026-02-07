extends Node2D
class_name HitListener

@export var SMALL_PUSHBACK := 110
@export var MEDIUM_PUSHBACK := 150
@export var BIG_PUSHBACK := 200
@export var SMALL_PUSHBACK_DURATION := 0.5
@export var MEDIUM_PUSHBACK_DURATION := 1
@export var BIG_PUSHBACK_DURATION := 1.5

@export var life_bar : TextureProgressBar

var vfx_player_scene : PackedScene = load("res://scenes/short_lived_vfx.tscn")

# Hit freeze durations (seconds)
const LIGHT_FRAME_FREEZE_DURATION  := 0.012
const NORMAL_FRAME_FREEZE_DURATION := 0.024
const BIG_FRAME_FREEZE_DURATION    := 0.038
const HUGE_FRAME_FREEZE_DURATION   := 0.056

@export var LIGHT_CAM_SHAKE : float = 2
@export var NORMAL_CAM_SHAKE : float = 3
@export var BIG_CAM_SHAKE : float = 4
@export var HUGE_CAM_SHAKE : float = 6

@export var min_guard_break_frame := -1
@export var max_guard_break_frame := 100

enum GuardResult {
	HIT,
	BLOCK,
	PARRY
}

var daddy : LivingEntity

func update_lifebar(dmg : int):
	if life_bar:
		life_bar.update_health_bar(dmg)

func handle_guard(area : HitBox) -> GuardResult:
	return GuardResult.HIT
	
func handle_guard_break(area : HitBox, current_state : State):
	if current_state.name.to_lower() == "guard" and area.is_guard_break:
		daddy.posture += (daddy.max_posture * 0.2)
		match daddy.poise_type:
			daddy.Poises.PLAYER:
				daddy.get_staggered()
				daddy.velocity.x += MEDIUM_PUSHBACK * area.facing
			daddy.Poises.SMALL:
				daddy.get_stunned(BIG_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.MEDIUM:
				daddy.get_stunned(BIG_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			daddy.Poises.LARGE:
				daddy.get_stunned(BIG_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
		create_label(Color.ROYAL_BLUE, "GUARD BROKEN!", 1.3)

func _ready() -> void:
	daddy = owner

#@export var LifeBar : TextureProgressBar
var shader_duration = 0.2
var shader_on_cooldown = false
var damage_label : PackedScene = preload("res://scenes/damage_text.tscn")
var crit_label : PackedScene = preload("res://scenes/crit_text.tscn")
var frozen_label : PackedScene = preload("res://scenes/frozen_text.tscn")
var burn_label : PackedScene = preload("res://scenes/burn_text.tscn")
var elec_label : PackedScene = preload("res://scenes/elec_text.tscn")

var dmg : DamageContainer = DamageContainer.new()

func _process(delta: float) -> void:
	# Handle hit shader cooldown
	if shader_on_cooldown:
		shader_duration -= delta
		if shader_duration <= 0:
			shader_on_cooldown = false
			daddy.anim_player.material.set_shader_parameter("enabled", false)

func create_label(color : Color, text : String, scale : float = 1.0, y_offset : int = 50, special := false):
		var dmg_text_instance = damage_label.instantiate()
		dmg_text_instance.position = global_position - Vector2(0, 10)
		dmg_text_instance.add_theme_color_override("font_color", color)
		if special:
			dmg_text_instance.add_theme_color_override("font_outline_color", Color.WHITE)
		dmg_text_instance.scale = Vector2(scale, scale)
		dmg_text_instance.text = text  # affiche la valeur
		get_tree().get_first_node_in_group("Level").add_child(dmg_text_instance)
		dmg_text_instance.position.y -= y_offset

func damage_taken(area : HitBox) -> void:
	var current_state : State = daddy.state_machine.get_current_state()
	
	# Recaluclate the facing (if multidirectional)
	if area.multidirectional:
		if area.owner.position.x < daddy.position.x:
			area.facing = 1
		else:
			area.facing = -1

	# Frame freeze and screen shake
	var cam = get_tree().get_first_node_in_group("Camera")
	match area.impact:
		HitBox.Impact.LIGHT:
			cam.trigger_shake(LIGHT_CAM_SHAKE)
			Toolbox.hit_freeze(LIGHT_FRAME_FREEZE_DURATION)

		HitBox.Impact.NORMAL:
			cam.trigger_shake(NORMAL_CAM_SHAKE)
			Toolbox.hit_freeze(NORMAL_FRAME_FREEZE_DURATION)

		HitBox.Impact.BIG:
			cam.trigger_shake(BIG_CAM_SHAKE)
			Toolbox.hit_freeze(BIG_FRAME_FREEZE_DURATION)

		HitBox.Impact.HUGE:
			cam.trigger_shake(HUGE_CAM_SHAKE)
			Toolbox.hit_freeze(HUGE_FRAME_FREEZE_DURATION)
	# Particles
	$GPUParticles2D.direction.x = area.facing
	$GPUParticles2D.emitting = true
	$GPUParticles2D.restart()

	# Verify the hit (GUARD)
	# GUARD HANDLING
	if not area.is_guard_break:
		var result = handle_guard(area)
		if result == GuardResult.BLOCK:
			create_label(Color.WHITE, "BLOCKED!", 1.3)
			return
		elif result == GuardResult.PARRY:
			create_label(Color.SKY_BLUE, "PARRIED!", 1.3)
			return

	# Taking damage and side effects
	# GETTING GUARD BROKEN
	handle_guard_break(area, current_state)

	# GETTING INTERRUPTED
	if current_state.name.to_lower() == "guardbreak" and area.is_phys_atk:
		if daddy.anim_player.frame >= min_guard_break_frame and daddy.anim_player.frame <= max_guard_break_frame:
			daddy.posture += (daddy.max_posture * 0.2)
			match daddy.poise_type:
				daddy.Poises.PLAYER:
					daddy.get_staggered()
					daddy.velocity.x += BIG_PUSHBACK * area.facing
				daddy.Poises.SMALL:
					daddy.get_stunned(BIG_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
				daddy.Poises.MEDIUM:
					daddy.get_stunned(BIG_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
				daddy.Poises.LARGE:
					daddy.get_stunned(BIG_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
			create_label(Color.MEDIUM_SLATE_BLUE, "INTERRUPTED!", 1.3)

	if daddy.get_state() != "staggered":
		daddy.posture += area.motion_value / 2
	if daddy.posture >= daddy.max_posture:
		daddy.posture = 0
		if daddy.poise_type != daddy.Poises.PLAYER:
			create_label(Color.REBECCA_PURPLE, "STAGGERED!", 1.5, 70)
			daddy.get_staggered(BIG_PUSHBACK * area.facing)

	dmg = area.generate_damage()
	dmg = daddy.take_damage(dmg)

	# Call the hitbox side effect
	area.on_hit()
	
	if daddy.poise_type == daddy.Poises.PLAYER:
		match area.push_back:
			area.Pushback.TICK:
				daddy.get_stunned(1 * area.facing, SMALL_PUSHBACK_DURATION)
			area.Pushback.NORMAL:
				daddy.get_stunned(2 * area.facing, SMALL_PUSHBACK_DURATION)
			area.Pushback.STRONG:
				daddy.get_stunned(2 * area.facing, SMALL_PUSHBACK_DURATION)
			area.Pushback.GINORMOUS:
				daddy.get_stunned(3 * area.facing, SMALL_PUSHBACK_DURATION)

	if daddy.is_in_group("Enemy"):
		print("Enemy taking a hit")
		if current_state is EnemyAttackState and current_state.option_type == EnemyAttackState.OptionType.DEFENSIVE:
			pass
		else:
			match daddy.poise_type:
				daddy.Poises.SMALL:
					match area.push_back:
						area.Pushback.NORMAL:
							daddy.get_stunned(SMALL_PUSHBACK * area.facing, SMALL_PUSHBACK_DURATION)
						area.Pushback.STRONG:
							daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
						area.Pushback.GINORMOUS:
							daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
				daddy.Poises.MEDIUM:
					print("Enemy is medium")
					match area.push_back:
						area.Pushback.NORMAL:
							print("NORMAL PUSHBACK")
							if daddy.velocity.x == 0:
								daddy.velocity.x += (area.facing * SMALL_PUSHBACK)
						area.Pushback.STRONG:
							print("STRON PUSHBACK")
							daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
						area.Pushback.GINORMOUS:
							print("GINORMOUS PUSHBACK")
							daddy.get_stunned(MEDIUM_PUSHBACK * area.facing, MEDIUM_PUSHBACK_DURATION)
				daddy.Poises.LARGE:
					pass

	# Hit flash
	daddy.anim_player.material.set_shader_parameter("enabled", true)
	shader_on_cooldown = true
	shader_duration = 0.2

	if area.attack_type != HitBox.AttackType.NONE:
		# Launch a vfx animation corresponding to the
		# caracteristics of the hit
		var dmg_vfx : ShortLivedVFX = vfx_player_scene.instantiate()
		add_child(dmg_vfx)
		if area.facing == -1:
			dmg_vfx.flip_h = true
		match area.attack_type:
			HitBox.AttackType.SLASH:
				dmg_vfx.play("slash")
			HitBox.AttackType.THRUST:
				dmg_vfx.play("thrust")
			HitBox.AttackType.BONK:
				dmg_vfx.play("bonk")

	# Dictionnaire type -> couleur
	var dmg_colors = {
		"fire": Color.ORANGE,
		"thunder": Color.YELLOW,
		"ice": Color.CYAN,
		"phys": Color.WHITE
	}

	var dmg_outlines = {
		"fire": Color.CORAL,
		"thunder": Color.LIGHT_YELLOW,
		"ice": Color.LIGHT_BLUE,
	}

	# Liste des dégâts et leur type
	var dmg_list = {
		"fire": dmg.fire_dmg,
		"thunder": dmg.thunder_dmg,
		"ice": dmg.ice_dmg,
		"phys": dmg.phys_dmg
	}

	# Pour chaque type de dégâts > 0, instancier le label avec la couleur correspondante
	for dmg_type in dmg_list.keys():
		var amount = dmg_list[dmg_type]
		if amount > 0:
			var dmg_text_instance = damage_label.instantiate()
			dmg_text_instance.position = global_position - Vector2(0, 10)
			if owner.is_in_group("Player"):
				dmg_text_instance.add_theme_color_override("font_color", Color.FIREBRICK)
			else:
				dmg_text_instance.add_theme_color_override("font_color", dmg_colors[dmg_type])
				if dmg_type != "phys":
					dmg_text_instance.add_theme_color_override("font_outline_color", dmg_outlines[dmg_type])
			dmg_text_instance.text = str(int(amount))  # affiche la valeur
			get_tree().get_first_node_in_group("Level").add_child(dmg_text_instance)
			dmg_text_instance.position.y -= 30

	# Critique
	if dmg.is_crit:
		var crit_text_instance = crit_label.instantiate()
		crit_text_instance.position = global_position - Vector2(0, 10)
		# On ne change pas le texte, le crit_label a son propre style
		get_tree().get_first_node_in_group("Level").add_child(crit_text_instance)
		crit_text_instance.position.y -= 30

	# Lifebar update
	update_lifebar(dmg.total_dmg)
