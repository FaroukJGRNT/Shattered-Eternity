extends  PlayerState

var acceleration = 10

func _ready() -> void:
	is_state_blocking = true

func update(delta):
	if not Input.is_action_pressed("guard") and player.velocity.x == 0 and AnimPlayer.animation != "guard_start":
		transitioned.emit("attackrecovery")
		AnimPlayer.play("guard_end")
	if player.velocity.x > 0:
		player.velocity.x -= acceleration
	if player.velocity.x < 0:
		player.velocity.x += acceleration
	player.move_and_slide()

func enter():
	player.velocity.x = 0
	$"../../ShieldHurtBox".monitoring = true
	$"../../ShieldHurtBox".disabled = false
	AnimPlayer.play("guard_start")

func exit():
	$"../../ShieldHurtBox".monitoring = false
	$"../../ShieldHurtBox".disabled = true

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	AnimPlayer.play("guard")
