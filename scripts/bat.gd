extends LivingEntity
class_name Bat

@export var SPEED = 150.0
@export var ATTACK_RANGE = 80
@export var wander_distance = 200
@export var max_aggro_distance = 1000

var offensive_actions : Array[EnemyState] = []
var ranged_offensive_actions : Array[EnemyState] = []
var defensive_actions : Array[EnemyState] = []

var last_decide_hp := life

enum Mode {
	CHILLIN,
	BASIC_AGGRO
}

var current_mode = Mode.CHILLIN

var target : LivingEntity
var direction := Vector2.ZERO

# Stats initialization
func _init() -> void:
	poise_type = Poises.SMALL
	max_life = 200
	life = max_life
	attack = 10
	defense = 10
	thunder_res = 2.0
	fire_res = 2.0
	ice_res = 2.0
	elem_mode = ElemMode.NONE

func _ready() -> void:
	# Gather our options
	for state in state_machine.get_children():
		if not state is EnemyAttackState:
			continue
		if state.option_type == EnemyAttackState.OptionType.OFFENSIVE:
			offensive_actions.append(state)
		elif state.option_type == EnemyAttackState.OptionType.RANGED_OFFENSIVE:
			ranged_offensive_actions.append(state)
		elif state.option_type == EnemyAttackState.OptionType.DEFENSIVE:
			defensive_actions.append(state)

# Formalities methods

func die():
	$EnemyStateMachine.on_state_transition("death")

func get_stunned(vel_x : float, duration : float):
	if $EnemyStateMachine.current_state.name != "Death" and $EnemyStateMachine.current_state.name != "Staggered":
		$EnemyStateMachine/Stun.push_back = vel_x
		$EnemyStateMachine/Stun.timeout = duration
		$EnemyStateMachine.on_state_transition("stun")

func get_staggered():
	if $EnemyStateMachine.current_state.name != "Death":
		$EnemyStateMachine.on_state_transition("staggered")

func get_state():
	return $EnemyStateMachine.get_current_state().name.to_lower()

# NOW THE REAL STUFF, THE BIG WIGS

func _physics_process(delta: float) -> void:
	var current_state : EnemyState = $EnemyStateMachine.get_current_state()

	if current_state.is_state_blocking:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	direct_sprite()

	if current_mode == Mode.BASIC_AGGRO:
		enemy_ai()

func is_target_in_close_range() -> bool:
	if position.distance_to(target.position) <= ATTACK_RANGE and\
	(position.x - target.position.x) * direction.x < 0 and is_on_floor():
		return true
	return false

func enemy_ai():
	
	# Are my attacks blocked a lot
		# Break guard (if you know how to)

	# Always see if you can back off
	if is_target_in_close_range():
		if randf_range(0, 1) >= 0.5:
			# Chose a defensive action
			var ready_acts = []
			for act in defensive_actions:
				if act.option_timer <= 0:
					ready_acts.append(act)

			var num = len(ready_acts)
			if num > 0:
				$EnemyStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
				last_decide_hp = life
				return
	
	last_decide_hp = life

	# Is the target far away
	if not is_target_in_close_range():
		# Choose randomly a ranged offens act (If no available, go closer)
		var ready_acts = []
		for act in ranged_offensive_actions:
			if act.option_timer <= 0:
				ready_acts.append(act)
		
		var num = len(ready_acts)
		if num > 0:
			$EnemyStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			$EnemyStateMachine.on_state_transition("chase")
			return
	# Is the target close
	else:
		#  Choose randomly a ready offens act
		var ready_acts = []
		for act in offensive_actions:
			if act.option_timer <= 0:
				ready_acts.append(act)

		var num = len(ready_acts)
		if num > 0:
			$EnemyStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			return

	# Potentially custom stuff: (Enemy behind me --> reverse)
	# Or is this nigga guardbreaking for no reason ? fuk u

func direct_sprite():
	# make sure he faces the right directionif velocity.x > 0:
	if velocity.x > 0:
		anim_player.flip_h = true
		$HitBoxes.scale.x = -1
		$HitBoxes.scale.y = 1
		$HurtBox.scale.x = -1
		facing = 1
	if velocity.x < 0:
		anim_player.flip_h = false
		$HitBoxes.scale.x = 1
		$HitBoxes.scale.y = 1
		$HurtBox.scale.x = 1
		facing = -1

# Handling aggro zone

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Player"):
		target = body
		current_mode = Mode.BASIC_AGGRO
		$EnemyStateMachine.on_state_transition("decide")


func _on_aggro_range_body_exited(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Player"):
		current_mode = Mode.CHILLIN
		$EnemyStateMachine.on_state_transition("wander")
		$EnemyStateMachine/Wander.wait_cooldown = 5.0
