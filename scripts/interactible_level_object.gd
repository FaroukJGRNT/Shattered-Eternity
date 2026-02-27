extends Node2D
class_name InteractibleLevelObject

var active := false
var player_ref : Player
var interacted := false

@export var offset := Vector2(0, -50)
@export var interaction_action := "interact"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		$HelpOverheadText.global_position = player_ref.global_position + offset
		if Input.is_action_just_pressed(interaction_action):
			interact()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		$HelpOverheadText.fade_in()
		player_ref = body
		active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		$HelpOverheadText.fade_out()
		active = false

func interact():
	print("Player interacted")
