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
var dash_cooldown := 1.0
var on_dash_cooldown := false
var aerial_dash_used := false
var hit_direction := 1

enum Weapons {
	SPEAR,
	SWORD,
	HAMMER
}

var direction
var current_weapon = Weapons.SWORD

# Stats
func _init() -> void:
	max_life = 200
	life = max_life
	attack = 80
	defense = 2
	thunder_res = 10.0
	fire_res = 10.0
	ice_res = 10.0

func take_damage(damage:DamageContainer):
	super.take_damage(damage)
	hit_direction = damage.facing
	change_state("hit")

func change_state(new_state):
	$PlayerStateMachine.on_state_transition(new_state)

func run_cooldowns(delta):
	if on_dash_cooldown:
		dash_cooldown -= delta
	if dash_cooldown <= 0:
		on_dash_cooldown = false

func _physics_process(delta: float) -> void:
	run_cooldowns(delta)

 	#------ Do nothing when in a blocking state ------#
	var current_state : PlayerState = $PlayerStateMachine.get_current_state()
	if current_state.is_state_blocking:
		return

	# Get the horizontal input and direct the sprite
	get_horizontal_input()
	direct_sprite()
	
	#------ Updating the player state ------#

	# on the ground
	if is_on_floor():
		aerial_dash_used = false
		# Determine if the player just landed
		if $PlayerStateMachine.current_state.name == "Airborne":
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
		$VFXPlayer.visible = true
		if $VFXPlayer.is_playing():
			$VFXPlayer.stop()
		$VFXPlayer.rotation = randf_range(0, 360)
		$VFXPlayer.play("weapon_change")
		current_weapon = (int(current_weapon) + 1) % 3

#------ Utility functions ------#

func handle_vertical_movement(delta):
	# Apply the gravity
	velocity.y += (get_gravity().y * delta)
	var friction = 0
	if is_on_wall():
		friction = 15
	if velocity.y >= 0:
		velocity.y -= friction
	move_and_slide()

func handle_horizontal_movement(speed):
	# Get the input direction and
	# handle the movement/deceleration
	if direction:
		velocity.x = direction * speed * global_speed_scale
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func direct_sprite():
	# Make the sprite and boxes face the right direction
	if direction <  0:
		$AnimatedSprite2D.flip_h = true
		$PlayerHurtBox.scale.x = -1
		$HitBoxes.scale.x = -1
		facing = -1
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
		$PlayerHurtBox.scale.x = 1
		$HitBoxes.scale.x = 1
		facing =  1

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
		change_state("jumpstart")
	initiate_slide()
	if Input.is_action_just_pressed("attack"):
		match current_weapon:
			Weapons.SWORD:
				change_state("swordattack1")
			Weapons.SPEAR:
				pass
			Weapons.HAMMER:
				change_state("hammerattack1")

func _on_vfx_player_animation_finished() -> void:
	$VFXPlayer.visible = false
	$VFXPlayer.position = Vector2(0, 0)

func on_attack_charged() -> void:
	$VFXPlayer.visible = true
	$VFXPlayer.position = Vector2(-20 * direction, -20)
	$VFXPlayer.play("full_charge")
