extends Label

var velocity = Vector2.ZERO
var gravity = 500.0
var bounce_factor = 0.4  # rebond plus petit à chaque fois
var start_y = 0
var direction = 1
var over = false

func _ready() -> void:
	start_y = position.y
	# vitesse initiale (aléatoire vers le haut et gauche/droite)
	velocity = Vector2(randf_range(0, 100) * direction, randf_range(-120, 0))
	$Timer.wait_time = randf_range(0.6, 1) # durée de vie max
	$Timer.start()

func _process(delta: float) -> void:
	if over:
		modulate.a -= delta
		if modulate.a <= 0:
			queue_free()
		return
	# appliquer gravité
	velocity.y += gravity * delta
	position += velocity * delta

	# gestion du rebond quand on touche le sol
	if position.y > start_y:
		position.y = start_y
		velocity.y = -velocity.y * bounce_factor

		# si le rebond devient trop faible, on arrête
		if abs(velocity.y) < 50:
			velocity.x = 0

func _on_timer_timeout() -> void:
	over = true
