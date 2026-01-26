extends LivingEntity
class_name BasicEnemy

@export var SPEED = 150.0
@export var ATTACK_RANGE = 80
@export var wander_distance = 200
@export var max_aggro_distance = 1000

@export var aggro_area : Area2D

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

# Stats initialization
func _init() -> void:
	poise_type = Poises.MEDIUM
	max_life = 500
	life = max_life
	attack = 12
	defense = 20
	thunder_res = 2.0
	fire_res = 2.0
	ice_res = 2.0
	elem_mode = ElemMode.NONE

func _ready() -> void:
	# Gather our options
	for state in state_machine.get_children():
		if state.option_type == EnemyState.OptionType.OFFENSIVE:
			offensive_actions.append(state)
		elif state.option_type == EnemyState.OptionType.RANGED_OFFENSIVE:
			ranged_offensive_actions.append(state)
		elif state.option_type == EnemyState.OptionType.DEFENSIVE:
			defensive_actions.append(state)
	aggro_area.connect("body_entered", _on_aggro_range_body_entered)
	aggro_area.connect("body_exited", _on_area_2d_body_exited)

# Formalities methods

func die():
	state_machine.on_state_transition("death")

func get_stunned(vel_x : float, duration : float):
	if state_machine.current_state.name != "Death" and state_machine.current_state.name != "Staggered":
		$EnemyStateMachine/Stun.push_back = vel_x
		$EnemyStateMachine/Stun.timeout = duration
		state_machine.on_state_transition("stun")

func get_staggered():
	if state_machine.current_state.name != "Death":
		state_machine.on_state_transition("staggered")

func get_state():
	return state_machine.get_current_state().name.to_lower()

# NOW THE REAL STUFF, THE BIG WIGS

func _physics_process(delta: float) -> void:
	var current_state : EnemyState = state_machine.get_current_state()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if current_state.is_state_blocking:
		return

	direct_sprite()

	if current_mode == Mode.BASIC_AGGRO:
		enemy_ai()

func is_target_close() -> bool:
	if abs(position.x - target.position.x) <= ATTACK_RANGE:
		return true
	else:
		return false

func is_target_in_front() -> bool:
	return ((target.position.x - position.x) * facing > 0)

func is_target_in_close_range() -> bool:
	return (is_target_close() and is_target_in_front())

func turn_around():
	if facing == -1:
		velocity.x = 1
	if facing == 1:
		velocity.x = -1
	direct_sprite()
	move_and_slide()

func enemy_ai():
	if not is_target_in_front():
		turn_around()

	# Are my attacks blocked a lot
		# Break guard (if you know how to)

	# Have I taken a lot of damage quickly
	if (last_decide_hp - life) >= (max_life / 6):
		# Chose a defensive action
		var ready_acts = []
		for act in defensive_actions:
			if act.option_timer <= 0:
				ready_acts.append(act)

		var num = len(ready_acts)
		if num > 0:
			state_machine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
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
			state_machine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			state_machine.on_state_transition("chase")
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
			state_machine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			return

	# Potentially custom stuff: (Enemy behind me --> reverse)
	# Or is this nigga guardbreaking for no reason ? fuk u

func direct_sprite():
	var state_name = state_machine.get_current_state().name.to_lower()
	if state_name == "stun" or state_name == "staggered":
		return
	# make sure he faces the right direction
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

# TODO: Replace by calculating distance to the player
func _on_area_2d_body_exited(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Player"):
		current_mode = Mode.CHILLIN
		state_machine.on_state_transition("wander")
		#state_machine/Wander.wait_cooldown = 5.0

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.is_in_group("Player"):
		target = body
		current_mode = Mode.BASIC_AGGRO
		state_machine.on_state_transition("decide")
