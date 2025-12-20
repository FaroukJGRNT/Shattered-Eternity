extends PlayerState

var attack_again := false
var parry_state := "idle"

func _ready() -> void:
	is_state_blocking = true
	
func enter():
	player.hurtbox.desactivate()
	parry_state = "idle"
	attack_again = false
	AnimPlayer.play("perfect_guard")

func update(delta):
	if Input.is_action_just_pressed("attack"):
		attack_again = true
		match player.current_weapon:
			player.Weapons.SWORD:
				parry_state = ("swordparry")
			player.Weapons.HAMMER:
				parry_state = ("hammerparry")
			player.Weapons.SPEAR:
				parry_state = ("spearparry")
				
	
func exit():
	player.hurtbox.activate()

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	transitioned.emit(parry_state)
