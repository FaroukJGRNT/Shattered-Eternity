extends EnemyAttackState

@export var attack_duration = 0.5

var attack_timer := 0.0

func enter():
	attack_timer = attack_duration
	usable_mov_frames = movement_frames.duplicate()
	usable_velocs = movement_velocity.duplicate()
	attack_ended = false
	AnimPlayer.play(anim_name)

func update(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		AnimPlayer.play("attack_end")
	super.update(delta)

func on_animation_end():
	if AnimPlayer.animation == "attack_end":
		get_parent().get_node("Recovery").timer = attack_cooldown
		AnimPlayer.play("idle")
		transitioned.emit("recovery")
