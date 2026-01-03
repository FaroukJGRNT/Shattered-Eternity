extends AnimatedSprite2D

@export var state_machine : PlayerStateMachine
@export var hitboxes : Node2D
@export var hurtbox : HurtBox

func _ready() -> void:
	process_priority = -100

func _process(delta: float) -> void:
	pass

func _on_frame_changed() -> void:
	if owner.dead:
		return
	# default reset
	hurtbox.activate()

	for hitbox in hitboxes.get_children():
		hitbox.desactivate()

	var current_state = state_machine.get_current_state()
	if current_state is AttackState:
		if frame in current_state.active_frames:
			if frame == current_state.active_frames[0]:
				current_state.hitbox.start_life()
			current_state.hitbox.activate()
			current_state.hitbox.facing = owner.facing
	if current_state is EvadeState:
		if frame in current_state.active_frames:
			hurtbox.desactivate()
