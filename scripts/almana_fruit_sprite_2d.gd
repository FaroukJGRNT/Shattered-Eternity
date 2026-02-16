extends Sprite2D

var base_y : float
var range : float = 12.0
var spd := 1.0
var time := 0.0

func _ready():
	base_y = position.y
	print("Base y: ", base_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	position.y = base_y + sin(time * spd) * range
