extends PlayerState

@export var stagger_duration := 2.0 
var cooldown := 0.0
var acceleration = 1.0

func _ready() -> void:
	is_state_blocking = true

func enter():
	cooldown = stagger_duration
	AnimPlayer.play("stagger_start")
	if not player.is_on_floor():
		transitioned.emit("airborne")

func update(delta):
	cooldown -= delta
	if cooldown <= 0 and player.velocity.x == 0:
		AnimPlayer.play("stagger_end")
	if player.velocity.x > 0:
		player.velocity.x = max(player.velocity.x - acceleration, 0)
	if player.velocity.x < 0:
		player.velocity.x = min(player.velocity.x + acceleration, 0)
	player.move_and_slide()

func exit():
	pass

func on_animation_end():
	if AnimPlayer.animation == "stagger_start":
		AnimPlayer.play("staggered")
	elif AnimPlayer.animation == "stagger_end":
		transitioned.emit("idle")
