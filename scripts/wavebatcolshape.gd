extends CollisionShape2D

@export var expansion_speed := 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shape.radius = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shape.radius += expansion_speed * delta
