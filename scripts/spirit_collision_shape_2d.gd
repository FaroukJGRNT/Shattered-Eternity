extends CollisionShape2D

@export var min_height := 140.0
@export var max_height := 152.0
@export var duration := 1.0

var tween: Tween

func _ready() -> void:
	# Sécurité
	if not shape or not shape is CapsuleShape2D:
		push_error("CollisionShape2D must use CapsuleShape2D")
		return

	start_oscillation()

func start_oscillation():
	tween = create_tween()
	tween.set_loops() # boucle infinie

	tween.tween_property(
		shape,
		"height",
		max_height,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		shape,
		"height",
		min_height,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
