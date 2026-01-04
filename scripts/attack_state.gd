extends PlayerState
class_name AttackState

@export var dash_cancel_frame : int
@export var recovery_state_name : String
@export var anim_name : String

@export var active_frames : Array[int]
@export var hitbox : HitBox

@export var movement_frames : Array[int]
@export var movement_velocity : Array[Vector2]

@export var deceleration := 10

var attack_again := false
@export var next_combo_state_name : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_state_blocking = true

func enter():
	attack_again = false
	AnimPlayer.play(anim_name)

func update(delta):
	var index = 0
	for frame in movement_frames:
		if AnimPlayer.frame == frame:
			player.velocity += (movement_velocity[index]) * player.facing
			player.move_and_slide()
		index += 1

	if Input.is_action_just_pressed("attack"):
		attack_again = true
	if Input.is_action_just_pressed("dash") and AnimPlayer.frame >= dash_cancel_frame:
		player.get_horizontal_input()
		if player.direction == 0 or player.direction * player.facing == -1:
			transitioned.emit("backdashing")
		else:
			transitioned.emit("dashing")

	#if len(movement_frames) == 0:
		#return
	#if player.velocity.x != 0:
		#if player.velocity.x > 0:
			#player.velocity.x = min(0, player.velocity.x - deceleration)
		#if player.velocity.x < 0:
			#player.velocity.x = max(0, player.velocity.x + deceleration)

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if recovery_state_name == "":
		recovery_state_name = "idle"
	if attack_again:
		if next_combo_state_name == "":
			AnimPlayer.play(recovery_state_name)
			transitioned.emit("attackrecovery")
		else:
			transitioned.emit(next_combo_state_name)
	else:
		AnimPlayer.play(recovery_state_name)
		transitioned.emit("attackrecovery")
