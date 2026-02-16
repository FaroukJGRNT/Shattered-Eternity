extends LivingEntity
class_name Player

var inventory : Array[Item]

func give_item(item : Item):
	inventory.append(item)

# Movement variables
@export var RUN_SPEED = 400.0
@export var AERIAL_SPEED = 150.0
@export var SLIDE_SPEED = 800.0
@export var JUMP_VELOCITY = -300.0
@export var SLIDE_DIST = 120.0
@export var BACKSLIDE_DIST = 80.0
@export var WALL_SLIDE_SPEED = 50.0
@export var MAX_VERTICAL_VELOC = 300.0

@export var max_resonance_value := 400.0
var resonance_value = 0.0

@export var specialVFXPlayer : SpecialVFXPlayer

var equipped_spell1 : Spell
var equipped_spell2 : Spell

var current_state : PlayerState

var dash_cooldown := 1.0
var change_weapon_cooldown = 0.1
var change_weapon_timer = 0.1
var on_dash_cooldown := false
var aerial_dash_used := false
var aerial_attack_used := false
var friction = 0
var allowed_jumps := 1
var acceleration = 85

enum Weapons {
	SPEAR,
	SWORD,
	HAMMER
}

var direction := 0.0
var current_weapon = Weapons.SWORD

# Stats
func _ready() -> void:
	super._ready()
	mana = 100
	poise_type = Poises.PLAYER
	position.x += 200
	max_life = 200
	life = max_life
	attack = 10
	defense = 10
	thunder_res = 10.0
	fire_res = 10.0
	ice_res = 10.0
	equip_spell_slot1(IceSpell.new())
	equip_spell_slot2(ThunderSpell.new())

@export var base_reson_decay := 2.0
@export var reson_decay_accel := 1.0
var reson_decay := 2.0
var attack_reson_boost := 5.0
var kill_reson_boost := 50.0
var parry_reson_boost := 80.0
var guard_break_reson_boost := 80.0
var interruption_reson_boost := 80.0
var dodge_reson_boost := 25.0

var hit_reson_loss := 75.0

func propagate_event(event : Event, additional : Variant = null):
	super.propagate_event(event)

	match event:
		Event.HIT_TAKEN:
			resonance_value -= hit_reson_loss
			if resonance_value < 0:
				resonance_value = 0
		
		Event.ENEMY_KILLED:
			resonance_value += kill_reson_boost
			reson_decay = base_reson_decay
		Event.PARRY:
			resonance_value += parry_reson_boost
			reson_decay = base_reson_decay
		Event.ATTACK_EVADED:
			resonance_value += dodge_reson_boost
			reson_decay = base_reson_decay
		Event.HIT_DEALT:
			resonance_value += attack_reson_boost
			reson_decay = base_reson_decay
		Event.ENEMY_GUARD_BROKEN:
			resonance_value += guard_break_reson_boost
			reson_decay = base_reson_decay
		Event.ENEMY_INTERRUPTED:
			resonance_value += interruption_reson_boost
			reson_decay = base_reson_decay

	if resonance_value > max_resonance_value:
		resonance_value = max_resonance_value
	

func get_stunned(vel_x : float, duration : float, perpretator):
	super.get_stunned(vel_x, duration, perpretator)
	if dead:
		return
	if get_state() == "staggered":
		if $PlayerStateMachine/Staggered.cooldown > 1.5:
			return
	if abs(vel_x) == 1:
		$PlayerStateMachine/Hit.hit_type = $PlayerStateMachine/Hit.HitType.TICK
	elif abs(vel_x) == 2:
		$PlayerStateMachine/Hit.hit_type = $PlayerStateMachine/Hit.HitType.NORMAL
	elif abs(vel_x) == 3:
		$PlayerStateMachine/Hit.hit_type = $PlayerStateMachine/Hit.HitType.GINORMOUS
	$PlayerStateMachine/Hit.hit_direction = sign(vel_x)
	if on_dash_cooldown:
		dash_cooldown = 0.0
	change_state("hit")

func get_staggered(x_vel : float = 0):
	if dead:
		return
	change_state("staggered")

func die():
	state_machine.on_state_transition("death")

func run_cooldowns(delta):
	reson_decay += reson_decay_accel * delta
	resonance_value = max(0, resonance_value - reson_decay * delta)

	if on_dash_cooldown:
		dash_cooldown -= delta
	if dash_cooldown <= 0:
		on_dash_cooldown = false
	change_weapon_timer -= delta
	if change_weapon_timer <= 0:
		change_weapon_timer = 0

# The process function makes sure the player is in the right state
func _physics_process(delta: float) -> void:
	adjust_cam(delta)
	if dead:
		return
	run_cooldowns(delta)

 	#------ Do nothing when in a blocking state ------#
	current_state = state_machine.get_current_state()
	if current_state.is_state_blocking:
		return

	# Get the horizontal input and direct the sprite
	get_horizontal_input()
	direct_sprite()
	
	#------ Updating the player state ------#

	# on the ground
	if is_on_floor():
		# Reset abilities
		allowed_jumps = 1
		aerial_dash_used = false
		aerial_attack_used = false
		# Determine if the player just landed
		if current_state.name == "Airborne":
			if resonance_value >= 100:
				change_state("running")
			else:
				change_state("landing")
			return
		# Determine if the player is running or not
		if direction != 0:
			change_state("running")
		else:
			if "Recovery" not in current_state.name:
				change_state("idle")
	# Updating the player state mid air
	else:
		change_state("airborne")

	if Input.is_action_just_pressed("change_weapon") and change_weapon_timer <= 0:
		change_weapon_timer = change_weapon_cooldown
		specialVFXPlayer.play_vfx("weapon_change")
		specialVFXPlayer.rotation_degrees = randf_range(0, 360)
		current_weapon = (int(current_weapon) + 1) % 3

	move_and_slide()

#------ Utility functions ------#

func handle_vertical_movement(gravity):
	if current_state.name.to_lower() != "wallsliding" and current_state is not AerialAttack:
		friction = 0
	# Apply the gravity
	velocity.y += gravity
	if velocity.y > 0:
		velocity.y = max(velocity.y - friction, 0)
	if velocity.y > MAX_VERTICAL_VELOC:
		velocity.y = MAX_VERTICAL_VELOC
	if velocity.y < -MAX_VERTICAL_VELOC:
		velocity.y = -MAX_VERTICAL_VELOC

func handle_horizontal_movement(speed, delta):
	# Get the input direction and
	# handle the movement/deceleration
	if direction > 0:
		velocity.x = min(velocity.x + acceleration * 50 * delta, (direction * speed * global_speed_scale))
	elif direction < 0:
		velocity.x = max(velocity.x - acceleration * 50 * delta, (direction * speed * global_speed_scale))
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * 50 * delta)

func direct_sprite():
	# Make the sprite and boxeshandle_horizontal face the right direction
	if direction <  0:
		$AnimatedSprite2D.flip_h = true
		$PlayerHurtBox.scale.x = -1
		$HitBoxes.scale.x = -1
		$RayCast2D.scale.x = -1
		facing = -1
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
		$PlayerHurtBox.scale.x = 1
		$HitBoxes.scale.x = 1
		$RayCast2D.scale.x = 1
		facing = 1

func adjust_cam(delta):

	if facing < 0:
		$Camera2D.drag_horizontal_offset = lerp($Camera2D.drag_horizontal_offset, -1.0, 2.0 * delta)
	if facing > 0:
		$Camera2D.drag_horizontal_offset = lerp($Camera2D.drag_horizontal_offset, 1.0, 2.0 * delta)

func get_horizontal_input():
	var raw = Input.get_axis("left", "right")

	if abs(raw) > 0.2:        # deadzone
		direction = sign(raw)  # devient -1 ou 1
	else:
		direction = 0.0

func initiate_slide():
	if Input.is_action_just_pressed("dash"):
		if is_on_floor() and not on_dash_cooldown:
			if direction == 0:
				change_state("backdashing")
			else:
				change_state("dashing")
			on_dash_cooldown = true
			dash_cooldown = 1.0
		elif not is_on_floor() and not aerial_dash_used:
			change_state("dashing")
			aerial_dash_used = true

func initiate_ground_actions():
	# Initiating a jump or a slide or an attack
	if Input.is_action_just_pressed("jump") and is_on_floor():
		allowed_jumps = 0
		change_state("jumpstart")
		return
	if Input.is_action_just_pressed("guard") and Input.is_action_just_pressed("attack"):
		change_state("guardbreak")
		return
	if Input.is_action_just_pressed("attack"):
		match current_weapon:
			Weapons.SWORD:
				change_state("swordattack1")
				return
			Weapons.SPEAR:
				change_state("spearattack1")
				return
			Weapons.HAMMER:
				change_state("hammerattack1")
				return
	if Input.is_action_just_pressed("guard"):
		change_state("guard")
		return
	initiate_slide()
	
	if Input.is_action_just_pressed("cast_spell1"):
		if mana >= equipped_spell1.mana_cost:
			state_machine.special_state_transition(equipped_spell1)
	if Input.is_action_just_pressed("cast_spell2"):
		if mana >= equipped_spell2.mana_cost:
			state_machine.special_state_transition(equipped_spell2)

func equip_spell_slot1(spell : Spell):
	equipped_spell1 = spell
	state_machine.connect_state(spell)

func equip_spell_slot2(spell : Spell):
	equipped_spell2 = spell
	state_machine.connect_state(spell)
