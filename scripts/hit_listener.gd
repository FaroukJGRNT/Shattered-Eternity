extends Node

@export var AnimPlayer : AnimatedSprite2D
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@export var LifeBar : TextureProgressBar
var shader_duration = 0.2
var shader_on_cooldown = false
var damage_label : PackedScene = preload("res://scenes/damage_text.tscn") 


func _on_enemy_damage_taken(dmg) -> void:
	# Screen shake and frame freeze is handled directly by the hitboxes and hutboxes	
	# Hit Particles
	
	# Hit flash
	AnimPlayer.material.set_shader_parameter("enabled", true)
	shader_on_cooldown = true
	shader_duration = 0.2
	# Damage show
	var dmg_text = damage_label.instantiate()
	dmg_text.position = Vector2(owner.position.x + (player.facing * 20), owner.position.y)
	dmg_text.direction = Vector2(player.facing, randi_range(-0.5, 0.5))
	add_child(dmg_text)
	# Lifebar update
	LifeBar.update_health_bar(dmg)
	
func _process(delta: float) -> void:
	if shader_on_cooldown:
		shader_duration -= delta
		if shader_duration <= 0:
			shader_on_cooldown = false
			AnimPlayer.material.set_shader_parameter("enabled", false)
