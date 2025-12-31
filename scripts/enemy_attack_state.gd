extends EnemyState
class_name EnemyAttackState

@export var anim_name : String = ""
@export var recov_anim_name : String = ""
@export var combo_state : String = ""
@export var active_frames : Array[int] = []
@export var hitbox : HitBox

@export var movement_frames : Array[int]
@export var movement_velocity : Array[Vector2]

@export var deceleration := 10


# During this time, the enemy will stay idle after attacking before moving again
@export var attack_cooldown : float = 0.0

var attack_ended := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_state_blocking = true

func enter():
	attack_ended = false
	AnimPlayer.play(anim_name)

func update(delta):
	var index = 0
	for frame in movement_frames:
		if AnimPlayer.frame == frame:
			enemy.velocity += (movement_velocity[index]) * enemy.facing
			enemy.move_and_slide()
		index += 1

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	if combo_state != "":
		transitioned.emit(combo_state)
		return
	get_parent().get_node("Recovery").timer = attack_cooldown
	print(get_parent().get_node("Recovery"))
	transitioned.emit("recovery")
	if recov_anim_name == "":
		recov_anim_name = "idle"
	AnimPlayer.play(recov_anim_name)
