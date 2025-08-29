extends LivingEntity
class_name Player

# Movement variables
@export var RUN_SPEED = 400.0
@export var AERIAL_SPEED = 150.0
@export var SLIDE_SPEED = 800.0
@export var JUMP_VELOCITY = -300.0
@export var SLIDE_DIST = 120.0
var direction = 0
var facing := 1

# Stats
func _init() -> void:
	max_life = 10000
	life = max_life 
	attack = 100
	defense = 10

func take_damage(damage:int):
	var total_dmg = damage - defense
	if total_dmg <= 0:
		total_dmg = 0
	life -= total_dmg
	change_state("hit")
	if life <= 0:
		life = 0
		die()

func change_state(new_state):
	$PlayerStateMachine.on_state_transition(new_state)

func _physics_process(delta: float) -> void:
 	#------ Do nothing when in a blocking state ------#
	var current_state = $PlayerStateMachine.get_current_state()
	if current_state == null or\
		current_state.name == "Hit" or\
		current_state.name == "Dashing":
		return
	
	# Get the horizontal input and direct the sprite
	get_horizontal_input()
	direct_sprite()
	#------ Updating the player state ------#

	# on the ground
	if is_on_floor():
		# Determine if the player is running or not
		if direction != 0:
			change_state("running")
		else:
			change_state("idle")


	# Updating the player state mid air
	else:
		change_state("airborne")


#------ Utility functions ------#

func handle_vertical_movement(delta):
	# Apply the gravity
	velocity.y += get_gravity().y * delta
	move_and_slide()

func handle_horizontal_movement(speed):
	# Get the input direction and
	# handle the movement/deceleration
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func direct_sprite():
	# Make the sprite and boxes face the right direction
	if direction <  0:
		$AnimatedSprite2D.flip_h = true
		$PlayerHurtBox.scale.x = -1
		facing = -1
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
		$PlayerHurtBox.scale.x = 1
		facing = 1

func get_horizontal_input():
	direction = Input.get_axis("left", "right")


func initiate_slide():
	if Input.is_action_just_pressed("dash"):
		change_state("dashing")

func initiate_ground_actions():
	# Initiating a jump or a slide or an attack
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		if velocity.x >= AERIAL_SPEED:
			velocity.x = AERIAL_SPEED
		change_state("airborne")
	initiate_slide()
	if Input.is_action_just_pressed("attack"):
		pass
