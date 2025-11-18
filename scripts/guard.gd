extends  PlayerState

var acceleration = 10

func _ready() -> void:
	is_state_blocking = true

func update(delta):
	print("Guarding veloc: ", player.velocity.x)
	if not Input.is_action_pressed("guard") and player.velocity.x == 0 and AnimPlayer.animation != "guard_start":
		transitioned.emit("attackrecovery")
		AnimPlayer.play("guard_end")
	if player.velocity.x > 0:
		player.velocity.x = max(player.velocity.x - acceleration, 0)
	if player.velocity.x < 0:
		player.velocity.x = min(player.velocity.x + acceleration, 0)
	player.move_and_slide()
	if Input.is_action_pressed("attack") and AnimPlayer.animation == "guard_start":
		transitioned.emit("guardbreak")
	if not player.is_on_floor():
		transitioned.emit("airborne")

func enter():
	player.velocity.x = 0
	$"../../ShieldHurtBox".set_deferred("monitoring", true)
	$"../../ShieldHurtBox".disabled = false
	AnimPlayer.play("guard_start")

func exit():
	$"../../ShieldHurtBox".set_deferred("monitoring", false)
	$"../../ShieldHurtBox".disabled = true

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	AnimPlayer.play("guard")
