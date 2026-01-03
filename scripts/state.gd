extends Node
class_name State

signal transitioned
var AnimPlayer : AnimatedSprite2D

var is_state_blocking = false

func enter():
	pass
	
func update(delta):
	pass
	
func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass

# Actually, some actions about frames must be decided here, not in uppdate
# Happy i found this bug bro
func on_frame_changed():
	pass
