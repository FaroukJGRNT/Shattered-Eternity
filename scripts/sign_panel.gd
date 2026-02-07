extends Panel

var fading_in := false
var fading_out := false

func _ready() -> void:
	modulate.a = 0.0
	$DescriptionText.set_anchors_preset(Control.PRESET_CENTER)

func fade_in():
	fading_out = false
	fading_in = true
	
func fade_out():
	fading_in = false
	fading_out = true

func _process(delta: float) -> void:
	if fading_in:
		modulate.a = lerp(modulate.a, 1.0, 8 * delta)
	elif fading_out:
		modulate.a = lerp(modulate.a, 0.0, 8 * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player detected")
		fade_in()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("leaving")
		fade_out()
