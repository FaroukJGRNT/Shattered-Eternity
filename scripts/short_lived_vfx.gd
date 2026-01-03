extends AnimatedSprite2D
class_name ShortLivedVFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var world_pos := global_position
	#get_tree().get_first_node_in_group("Level").add_child(self)
	#global_position = world_pos
	pass

func _on_animation_finished() -> void:
	queue_free()
