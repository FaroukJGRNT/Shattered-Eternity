extends EnemyState
class_name EnemyAttackState

@export var anim_name : String = ""
@export var recov_anim_name : String = ""
@export var combo_state : String = ""
@export var active_frames : Array[int] = []
@export var hitbox : HitBox

@export var movement_frames : Array[int]
@export var movement_velocity : Array[Vector2]

var usable_mov_frames : Array[int]
var usable_velocs : Array[Vector2]

@export var deceleration := 10


# During this time, the enemy will stay idle after attacking before moving again
@export var attack_cooldown : float = 0.0

var attack_ended := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_state_blocking = true

func enter():
	enemy.velocity = Vector2.ZERO
	usable_mov_frames = movement_frames.duplicate()
	usable_velocs = movement_velocity.duplicate()
	attack_ended = false
	AnimPlayer.play(anim_name)

func update(delta):
	var index = 0
	for frame in usable_mov_frames:
		if AnimPlayer.frame == frame:
			enemy.velocity.x += (usable_velocs[index].x) * enemy.facing
			enemy.velocity.y += (usable_velocs[index].y)
			usable_mov_frames.pop_front()
			usable_velocs.pop_front()
			break
		index += 1

	if enemy.velocity.x > 0:
		enemy.velocity.x = max(enemy.velocity.x - deceleration, 0)
	if enemy.velocity.x < 0:
		enemy.velocity.x = min(enemy.velocity.x + deceleration, 0)
	enemy.move_and_slide()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if combo_state != "":
		transitioned.emit(combo_state)
		return
	get_parent().get_node("Recovery").timer = attack_cooldown
	transitioned.emit("recovery")
	if recov_anim_name == "":
		recov_anim_name = "idle"
	AnimPlayer.play(recov_anim_name)

func on_frame_changed() -> void:
	pass
