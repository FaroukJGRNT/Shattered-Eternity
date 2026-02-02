extends Node
class_name EnemyStateMachine

@onready var AnimPlayer : AnimatedSprite2D = owner.anim_player
@onready var enemy : LivingEntity = owner
var current_state : EnemyState
var states : Dictionary = {}

func _ready() -> void:
	AnimPlayer.connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	# Gather all different states in the dictionnary
	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_transition)
			child.AnimPlayer = AnimPlayer
			child.enemy = enemy
	current_state = states["wander"]

func _process(delta: float) -> void:
	for child in get_children():
		if child is EnemyAttackState:
			child.option_timer = max(child.option_timer - delta, 0)
	if current_state:
		current_state.update(delta)

func on_state_transition(new_state_name):
	if enemy.dead and new_state_name != "death":
		return
	if states[new_state_name] != current_state:
		current_state.exit()
		if current_state is EnemyAttackState:
			current_state.option_timer = current_state.option_cooldown
		current_state = states[new_state_name.to_lower()]
		current_state.enter()

func get_current_state():
	return current_state

func _on_animated_sprite_2d_animation_finished() -> void:
	current_state.on_animation_end()
