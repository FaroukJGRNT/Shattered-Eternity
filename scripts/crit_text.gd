extends Label

var over = false
var velocity = Vector2.ZERO
var direction = 0

func _ready() -> void:
	# vitesse initiale (aléatoire vers le haut et gauche/droite)
	velocity = Vector2(randf_range(0, 50) * direction, randf_range(0, -30))
	$Timer.wait_time = randf_range(0.3, 0.6) # durée de vie max
	$Timer.start()

func _process(delta: float) -> void:
	if over:
		modulate.a -= delta * 2
		if modulate.a <= 0:
			queue_free()
		return
	position += velocity * delta

func _on_timer_timeout() -> void:
	over = true
