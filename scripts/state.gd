extends Node
class_name State

signal transitioned
var AnimPlayer : AnimatedSprite2D

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
