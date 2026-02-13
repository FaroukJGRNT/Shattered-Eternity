extends AnimatedSprite2D
class_name BasicAnimPlayer

@export var hurtbox : HurtBox
@export var hitboxes : Node2D
@export var state_machine : StateMachine
var active_hitboxes : Array[HitBox] =  []

var speed_multipliers : Array[float] = []
var base_speed := 1.0

func _ready() -> void:
	connect("frame_changed", _on_frame_changed)

func _process(delta: float) -> void:
	var spd = base_speed
	for m in speed_multipliers:
		spd *= m
	speed_scale = spd


func _on_frame_changed() -> void:
	# default reset
	if hurtbox.disabled:
		hurtbox.activate()

	for hitbox in active_hitboxes:
		hitbox.desactivate()
	active_hitboxes.clear()

	var current_state = state_machine.get_current_state()
	if current_state == null:
		return
	if current_state is EnemyAttackState or  current_state is AttackState:
		if frame in current_state.active_frames and current_state.hitbox:
			if frame == current_state.active_frames[0] and not current_state.hitbox.in_life:
				current_state.hitbox.start_life()
			current_state.hitbox.activate()
			active_hitboxes.append(current_state.hitbox)
			current_state.hitbox.facing = owner.facing

	if current_state is EvadeState:
		if frame in current_state.active_frames:
			hurtbox.desactivate()
