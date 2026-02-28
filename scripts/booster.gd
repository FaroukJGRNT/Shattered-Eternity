extends Node2D
class_name Booster

var used := false
var player_ref : Player
@export var offset := Vector2(0, -40)
var label_scene : PackedScene = load("res://ui/atoms/simple_fading_label.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not used:
		used = true
		player_ref = body
		interact()

func interact():
		var label = Toolbox.spawn_anything(player_ref, label_scene, offset)
		label.text = "Stats boosted!"
		player_ref.life = player_ref.max_life
		
		player_ref.attack *= 1.1
		player_ref.defense *= 1.1
