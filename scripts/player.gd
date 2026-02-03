extends LivingEntity
class_name Player

# Movement variables
@export var RUN_SPEED = 400.0
@export var AERIAL_SPEED = 150.0
@export var SLIDE_SPEED = 800.0
@export var JUMP_VELOCITY = -300.0
@export var SLIDE_DIST = 120.0
@export var BACKSLIDE_DIST = 80.0
@export var WALL_SLIDE_SPEED = 50.0
@export var MAX_VERTICAL_VELOC = 300.0

@export var specialVFXPlayer : SpecialVFXPlayer

var current_state : PlayerState

var dash_cooldown := 1.0
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

var direction
var current_weapon = Weapons.SWORD

# Stats
func _init() -> void:
	poise_type = Poises.PLAYER
	position.x += 200
	max_life = 200
	life = max_life
	attack = 10
	defense = 10
	thunder_res = 10.0
	fire_res = 10.0
	ice_res = 10.0

func get_stunned(vel_x : float, duration : float):
	if get_state() == "staggered":
		if $PlayerStateMachine/Staggered.cooldown > 1.5:
			return
	$PlayerStateMachine/Hit.hit_direction = sign(vel_x)
	if on_dash_cooldown:
		dash_cooldown = 0.0
	change_state("hit")

func get_staggered():
	change_state("staggered")

func run_cooldowns(delta):
	if on_dash_cooldown:
		dash_cooldown -= delta
	if dash_cooldown <= 0:
		on_dash_cooldown = false

# The process function makes sure the player is in the right state
func _physics_process(delta: float) -> void:
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

	if Input.is_action_just_pressed("change_weapon"):
		specialVFXPlayer.play_vfx("weapon_change")
		specialVFXPlayer.rotation_degrees = randf_range(0, 360)
		current_weapon = (int(current_weapon) + 1) % 3

	move_and_slide()

#------ Utility functions ------#

func handle_vertical_movement(gravity):
	# Apply the gravity
	velocity.y += gravity
	if velocity.y >= 0:
		velocity.y -= friction
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

func get_horizontal_input():
	direction = Input.get_axis("left", "right")

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
