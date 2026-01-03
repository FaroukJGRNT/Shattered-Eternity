extends Label

var velocity = Vector2.ZERO
var over = false

@export var duration := 0.8
@export var vert_velocity = -10.0
@export var horiz_velocity_range = 20.0
@export var deceleration := 120.0

func _ready() -> void:
	z_index = 900
	velocity = Vector2(
		randf_range(-horiz_velocity_range, horiz_velocity_range),
		vert_velocity
	)
	$Timer.wait_time = duration
	$Timer.start()

func _process(delta: float) -> void:
	if over:
		#scale -= Vector2.ONE * delta 
		modulate.a -= delta
		if modulate.a <= 0:
			queue_free()
		return

	# déplacement
	position += velocity * delta

	# décélération progressive
	velocity = velocity.move_toward(Vector2.ZERO, deceleration)

func _on_timer_timeout() -> void:
	over = true
