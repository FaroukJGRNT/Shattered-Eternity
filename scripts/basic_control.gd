extends Control
class_name BasicControl

var fading_in := false
var fading_out := false

func _ready() -> void:
	modulate.a = 0

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
