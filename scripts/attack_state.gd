extends PlayerState
class_name AttackState

@export var dash_cancel_frame : int
@export var recovery_state_name : String
@export var anim_name : String

@export var active_frames : Array[int] = [0]
@export var hitbox : HitBox

@export var movement_frames : Array[int]
@export var movement_velocity : Array[Vector2]

@export var deceleration := 10

var attack_again := false
@export var next_combo_state_name : String = ""
var usable_mov_frames : Array[int]
var usable_velocs : Array[Vector2]
@export var initial_veloc_multiplier := 0.0

@export var spawns_proj := false
@export var spawn_frame := 0
var proj_spawned := false

@export var reson_speed_boost := 1.3

func spawn_proj():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_state_blocking = true

func enter():
	if player.resonance_value >= 200:
		AnimPlayer.speed_multipliers.append(reson_speed_boost)

	proj_spawned = false
	attack_again = false
	player.velocity *= initial_veloc_multiplier
	usable_mov_frames = movement_frames.duplicate()
	usable_velocs = movement_velocity.duplicate()
	AnimPlayer.play(anim_name)

func update(delta):
	if AnimPlayer.frame == spawn_frame and not proj_spawned:
		proj_spawned = true
		spawn_proj()

	var index = 0
	for frame in usable_mov_frames:
		if AnimPlayer.frame == frame:
			player.velocity.x  += (usable_velocs[index].x) * player.facing
			player.velocity.y  += (usable_velocs[index].y)
			usable_mov_frames.pop_front()
			usable_velocs.pop_front()
			break
		index += 1

	if player.velocity.x > 0:
		player.velocity.x = max(player.velocity.x - deceleration * delta * 50, 0)
	if player.velocity.x < 0:
		player.velocity.x = min(player.velocity.x + deceleration * delta * 50, 0)
	if player.velocity.y > 0:
		player.velocity.y = max(player.velocity.y - deceleration * delta * 50, 0)
	if player.velocity.y < 0:
		player.velocity.y = min(player.velocity.y + deceleration * delta * 50, 0)
	player.move_and_slide()

	if Input.is_action_just_pressed("attack") and AnimPlayer.frame >= (AnimPlayer.sprite_frames.get_frame_count(AnimPlayer.animation) / 2):
		attack_again = true
	if AnimPlayer.frame < active_frames[0] or AnimPlayer.frame >= dash_cancel_frame:
		# Initiating a jump or a slide or an attack
		if Input.is_action_just_pressed("jump") and player.is_on_floor():
			player.allowed_jumps = 0
			player.change_state("jumpstart")
			return
		if Input.is_action_just_pressed("guard") and player.is_on_floor():
			player.change_state("guard")
			return
		if Input.is_action_just_pressed("dash"):
			player.get_horizontal_input()
			if player.direction == 0 or player.direction * player.facing == -1:
				transitioned.emit("backdashing")
			else:
				transitioned.emit("dashing")

func exit():
	if player.resonance_value >= 200:
		AnimPlayer.speed_multipliers.erase(reson_speed_boost)
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
