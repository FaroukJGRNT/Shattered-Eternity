extends EnemyState

var timer = 0.0

func _init() -> void:
	is_state_blocking = true

func update(delta):
	timer -= delta
	if timer <= 0:
		transitioned.emit("decide")
