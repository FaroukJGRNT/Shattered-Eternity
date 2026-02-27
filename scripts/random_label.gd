@tool
extends Label

var base_y : float
var range : float = 8.0
var spd := 1.3
var time := 0.0

func _ready():
	base_y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	position.y = base_y + sin(time * spd) * range
