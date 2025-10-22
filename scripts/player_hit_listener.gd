extends Node2D

@export var AnimPlayer : AnimatedSprite2D
@export var VFXPlayer : AnimatedSprite2D
#@export var LifeBar : TextureProgressBar
var shader_duration = 0.2
var shader_on_cooldown = false
var damage_label : PackedScene = preload("res://scenes/damage_text.tscn")
var crit_label : PackedScene = preload("res://scenes/crit_text.tscn")
var frozen_label : PackedScene = preload("res://scenes/frozen_text.tscn")
var burn_label : PackedScene = preload("res://scenes/burn_text.tscn")
var elec_label : PackedScene = preload("res://scenes/elec_text.tscn")

func _process(delta: float) -> void:
	if shader_on_cooldown:
		shader_duration -= delta
		if shader_duration <= 0:
			shader_on_cooldown = false
			AnimPlayer.material.set_shader_parameter("enabled", false)

func _on_player_damage_taken(dmg : DamageContainer) -> void:
	# Particles
	$GPUParticles2D.direction.x = dmg.facing
	$GPUParticles2D.emitting = true
	$GPUParticles2D.restart()

	# Hit flash
	AnimPlayer.material.set_shader_parameter("enabled", true)
	shader_on_cooldown = true
	shader_duration = 0.2
	
	# TODO: Launch a vfx animation corresponding to the
	# caracteristics of the hit
	
	# Dictionnaire type -> couleur
	var dmg_colors = {
		"fire": Color.ORANGE,
		"thunder": Color.YELLOW,
		"ice": Color.CYAN,
		"phys": Color.WHITE
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
			dmg_text_instance.position = Vector2(position.x + (dmg.facing * 5), position.y - 20)
			dmg_text_instance.direction = dmg.facing
			if owner.is_in_group("Player"):
				dmg_text_instance.add_theme_color_override("font_color", Color.INDIAN_RED)
			else:
				dmg_text_instance.add_theme_color_override("font_color", dmg_colors[dmg_type])
			dmg_text_instance.text = str(int(amount))  # affiche la valeur
			add_child(dmg_text_instance)

	# Critique
	if dmg.is_crit:
		var crit_text_instance = crit_label.instantiate()
		crit_text_instance.position = Vector2(position.x + (dmg.facing * 5), position.y - 30)
		crit_text_instance.direction = dmg.facing
		# On ne change pas le texte, le crit_label a son propre style
		add_child(crit_text_instance)

	 #Lifebar update
	#LifeBar.update_health_bar(dmg.total_dmg)
