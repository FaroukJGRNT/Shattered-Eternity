extends PlayerState

@export var stagger_duration := 2.5 
var cooldown := 0.0
var acceleration = 10

func _ready() -> void:
	is_state_blocking = true

func enter():
	cooldown = stagger_duration
	AnimPlayer.play("staggered")
	if not player.is_on_floor():
		transitioned.emit("airborne")

func update(delta):
	cooldown -= delta
	if cooldown <= 0 and player.velocity.x == 0:
		transitioned.emit("idle")
	if player.velocity.x > 0:
		player.velocity.x = max(player.velocity.x - acceleration, 0)
	if player.velocity.x < 0:
		player.velocity.x = min(player.velocity.x + acceleration, 0)
	player.move_and_slide()

func exit():
	pass
