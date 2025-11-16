extends PlayerState

func _ready() -> void:
	is_state_blocking = true
	
func enter():
	AnimPlayer.play("perfect_guard")

func update(delta):
	if Input.is_action_just_pressed("attack"):
		match player.current_weapon:
			player.Weapons.SWORD:
				transitioned.emit("swordparry")
			player.Weapons.HAMMER:
				transitioned.emit("hammerparry")
			player.Weapons.SPEAR:
				transitioned.emit("spearparry")

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit("idle")
