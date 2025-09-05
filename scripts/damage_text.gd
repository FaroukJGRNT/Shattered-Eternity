extends Label

var direction = Vector2(0, 0)
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = randf_range(0.4, 0.6)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	speed -= 1

func _on_timer_timeout() -> void:
	queue_free()
