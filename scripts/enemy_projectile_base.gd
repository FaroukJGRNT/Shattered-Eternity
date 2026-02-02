extends Projectile
class_name ProjectileTemplate

#The projectile template adds quality of life features
#to make creating projectiles a lot easier

# Allows to eaily control things based on the animations
func _ready() -> void:
	super._ready()
	if anim_player:
		anim_player.connect("animation_finished", on_anim_finished)
		anim_player.connect("frame_changed", on_frame_changed)

func on_anim_finished():
	pass

func on_frame_changed():
	pass
