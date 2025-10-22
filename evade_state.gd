extends PlayerState
class_name EvadeState

@export var active_frames : Array[int]
@export var hurtbox : HurtBox

func _ready() -> void:
	is_state_blocking = true
