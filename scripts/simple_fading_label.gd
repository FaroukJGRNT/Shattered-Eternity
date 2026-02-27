extends Label

@export var dist_y := 50.0
@export var spd := 2.0
@export var fade_spd := 2.0
@export var fade_treshold := 40.0
@export var end_treshold := 0.01
var base_y := 0.0

func _ready() -> void:
	base_y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = lerp(position.y, base_y - dist_y, delta * spd)
	
	if abs(base_y - position.y) >= fade_treshold:
		modulate.a = lerp(modulate.a, 0.0, delta * fade_spd)
		if modulate.a <= end_treshold:
			queue_free()
