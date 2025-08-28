extends LivingEntity
class_name Player

# Movement variables
@export var RUN_SPEED = 400.0
@export var AERIAL_SPEED = 150.0
@export var SLIDE_SPEED = 1000.0
@export var JUMP_VELOCITY = -300.0
@export var SLIDE_DIST = 100.0

# Stats
func _init() -> void:
	max_life = 10000
	life = max_life 
	attack = 100
	defense = 10

enum State {
	IDLE,
	RUNNING,
	GOING_UP,
	FALLING,
	SLIDING,
	ATTACK1,
	ATTACK2,
	TRANSITIONNING
}

var state = State.IDLE
var direction = 0
var attack_again = false
var new_state
var slide_direction 
var slide_start
var facing := 1

func handle_sliding():
	if abs(position.x - slide_start) < SLIDE_DIST:
		velocity.x = slide_direction * SLIDE_SPEED
	else:
		velocity.x = slide_direction * SLIDE_SPEED / 4
		
	if Input.is_action_just_pressed("jump"):
		print("Slide Jump!")
		velocity.y = JUMP_VELOCITY
		state = State.GOING_UP
	move_and_slide()

func initiate_ground_actions():
	# Initiating a jump or a slide or an attack
	if Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("jump_start")
		velocity.y = JUMP_VELOCITY
		if velocity.x >= AERIAL_SPEED:
			velocity.x = AERIAL_SPEED
		state = State.TRANSITIONNING
		new_state = State.GOING_UP
	if Input.is_action_just_pressed("down"):
		if direction != 0:
			slide_direction = direction
		else:
			if $AnimatedSprite2D.flip_h == true:
				slide_direction = -1
			else:
				slide_direction = 1
		slide_start = position.x
		state = State.SLIDING
	if Input.is_action_just_pressed("attack"):
		attack_again = false
		state = State.ATTACK1

func _physics_process(delta: float) -> void:
	handle_animation()

	direction = Input.get_axis("left", "right")
	# Do nothing during a transition
	if state == State.TRANSITIONNING:
		if new_state == State.RUNNING:
			handle_horizontal_movement(RUN_SPEED - 25)
			initiate_ground_actions()
		return
	# Updating the player state on the ground
	if is_on_floor():
		# if sliding, just keep sliding or interrupt with a jump
		if state == State.SLIDING:
			handle_sliding()
			return
		if state == State.ATTACK1:
			if Input.is_action_just_pressed("attack"):
				print("Attacking again")
				attack_again = true
			return
		if state == State.ATTACK2:
			return

		# Determine if the player is running or not
		if direction != 0:
			if state == State.IDLE:
				$AnimatedSprite2D.play("idle_to_run")
				state = State.TRANSITIONNING
				new_state = State.RUNNING
				direct_sprite()
				return
			state = State.RUNNING
		else:
			state = State.IDLE
		initiate_ground_actions()
		handle_horizontal_movement(RUN_SPEED)

	# Updating the player state mid air
	else:
		handle_vertical_movement(delta)
		handle_horizontal_movement(AERIAL_SPEED)

	direct_sprite()

func handle_vertical_movement(delta):
	velocity.y += get_gravity().y * delta
	# Determining if Going up or Falling down
	if velocity.y <= 0:
		state = State.GOING_UP
	else:
		state = State.FALLING
	move_and_slide()

func handle_horizontal_movement(speed):
	# Get the input direction and handle the movement/deceleration
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()

func direct_sprite():
	if direction <  0:
		$AnimatedSprite2D.flip_h = true
	if direction > 0:
		$AnimatedSprite2D.flip_h = false

func handle_animation():
	if state == State.IDLE:
		$AnimatedSprite2D.play("idle")
	if state == State.RUNNING:
		$AnimatedSprite2D.play("run")
	if state == State.GOING_UP:
		$AnimatedSprite2D.play("jump")
	if state == State.FALLING:
		$AnimatedSprite2D.play("fall")
	if state == State.SLIDING:
		$AnimatedSprite2D.play("slide")
	if state == State.ATTACK1:
		$AnimatedSprite2D.play("attack1")
	if state == State.ATTACK2:
		$AnimatedSprite2D.play("attack2")

func _on_animated_sprite_2d_animation_finished() -> void:
	if state == State.SLIDING:
		state = State.RUNNING
	elif state == State.ATTACK1:
		if attack_again:
			state = State.ATTACK2
		else:
			state = State.IDLE
	elif state == State.ATTACK2:
		state = State.IDLE
	elif state == State.TRANSITIONNING:
		state = new_state
