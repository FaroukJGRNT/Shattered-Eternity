extends EnemyState
class_name EnemyAttackState

@export var anim_name : String = ""
@export var recov_anim_name : String = ""
@export var active_frames : Array[int] = []
@export var hitbox : HitBox
@export var attack_cooldown : float = 0.0

var attack_ended := false
var timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_state_blocking = true

func enter():
	timer = 0.0
	attack_ended = false
	AnimPlayer.play(anim_name)

func update(delta):
	timer += delta
	if timer >= attack_cooldown and attack_ended:
		transitioned.emit("chase")

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	attack_ended = true
	if recov_anim_name == "":
		recov_anim_name = "idle"
	AnimPlayer.play(recov_anim_name)
