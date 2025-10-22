extends PlayerState
class_name ChargingState
signal attack_charged

@export var charge_time : float
@export var charge_animation : String
@export var charge_end_animation : String
@export var cancel_animation : String
@export var attack_state : String

var timer := 0.0


var emitted := false

func _ready() -> void:
	is_state_blocking = true

func enter():
	emitted = false
	timer = charge_time
	print("Timer set to ", charge_time)
	AnimPlayer.play(charge_animation)

func update(delta):
	timer -= delta

	if timer <= 0:
		AnimPlayer.play(charge_end_animation)
		if not emitted:
			emitted = true
			attack_charged.emit()

	if not Input.is_action_pressed("attack") and timer > 0:
		transitioned.emit("attackrecovery")
		AnimPlayer.play(cancel_animation)
		return

	if not Input.is_action_pressed("attack") and timer <= 0:
		transitioned.emit(attack_state)
		return

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
