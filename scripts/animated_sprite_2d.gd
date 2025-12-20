extends AnimatedSprite2D

@export var hurtbox : HurtBox
@export var hitboxes : Node2D
@export var state_machine : EnemyStateMachine

func _process(delta: float) -> void:
	pass

func _on_frame_changed() -> void:
	# default reset
	hurtbox.activate()
	
	for hitbox in hitboxes.get_children():
		hitbox.desactivate()

	var current_state = state_machine.get_current_state()
	if current_state is EnemyAttackState:
		if frame in current_state.active_frames:
			current_state.hitbox.activate()
			current_state.hitbox.facing = owner.facing

	if current_state is EvadeState:
		if frame in current_state.active_frames:
			hurtbox.desactivate()
