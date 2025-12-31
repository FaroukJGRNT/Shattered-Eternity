extends LivingEntity
class_name FGolem

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
var direction
var can_attack = true
var hit_counter := 0

# Stats initialization
func _init() -> void:
	poise_type = Poises.MEDIUM
	max_life = 300
	life = max_life
	attack = 60
	defense = 30
	thunder_res = 2.0
	fire_res = 2.0
	ice_res = 2.0
	direction = facing
	elem_mode = ElemMode.NONE

func _ready() -> void:
	# Gather our options
	for state in $FGolemStateMachine.get_children():
		if state.option_type == EnemyState.OptionType.OFFENSIVE:
			offensive_actions.append(state)
		elif state.option_type == EnemyState.OptionType.RANGED_OFFENSIVE:
			ranged_offensive_actions.append(state)
		elif state.option_type == EnemyState.OptionType.DEFENSIVE:
			defensive_actions.append(state)

# Formalities methods

func die():
	# Just for now lol
	queue_free()

func get_stunned(vel_x : float, duration : float):
	if $FGolemStateMachine.current_state.name != "Death":
		$FGolemStateMachine/Stun.push_back = vel_x
		$FGolemStateMachine/Stun.timeout = duration
		$FGolemStateMachine.on_state_transition("stun")

func get_staggered():
	if $FGolemStateMachine.current_state.name != "Death":
		$FGolemStateMachine.on_state_transition("staggered")

func get_state():
	return $FGolemStateMachine.get_current_state().name.to_lower()

# NOW THE REAL STUFF, THE BIG WIGS

func _physics_process(delta: float) -> void:
	var current_state : EnemyState = $FGolemStateMachine.get_current_state()

	if current_state.is_state_blocking:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	direct_sprite()

	if current_mode == Mode.BASIC_AGGRO:
		enemy_ai()

func is_target_in_close_range() -> bool:
	if abs(position.x - target.position.x) <= ATTACK_RANGE and\
	(position.x - target.position.x) * direction.x < 0:
		return true
	return false

func enemy_ai():
	
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
			$FGolemStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
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
			$FGolemStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			$FGolemStateMachine.on_state_transition("chase")
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
			$FGolemStateMachine.on_state_transition(ready_acts[randi_range(0, len(ready_acts)) - 1].name.to_lower())
		else:
			return

	# Potentially custom stuff: (Enemy behind me --> reverse)
	# Or is this nigga guardbreaking for no reason ? fuk u

func direct_sprite():
	# make sure he faces the right direction
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$HitBoxes.scale.x = -1
		$HitBoxes.scale.y = 1
		$HurtBox.scale.x = -1
		facing = -1
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$HitBoxes.scale.x = 1
		$HitBoxes.scale.y = 1
		$HurtBox.scale.x = 1
		facing = 1

# Handling aggro zone

# TODO: Replace by calculating distance to the player
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		current_mode = Mode.CHILLIN
		$FGolemStateMachine.on_state_transition("wander")
		$FGolemStateMachine/Wander.wait_cooldown = 5.0

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Now aggro")
		target = body
		current_mode = Mode.BASIC_AGGRO
		$FGolemStateMachine.on_state_transition("decide")
