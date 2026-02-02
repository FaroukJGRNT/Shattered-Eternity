extends ProjectileTemplate
class_name SpiritSpit

@export var JUMP_VELOCITY := -180.0
@export var HORIZ_VELOCITY := 150.0
@export var GRAVITY := 10.0
@export var GRAVITY_ACCEL := 0.0

var facing := 1

var velocity := Vector2.ZERO

var splash : ShortLivedVFX

func _ready() -> void:
	super._ready()

	splash = Toolbox.spawn_vfx(self, "spirit_splash")
	velocity.y += JUMP_VELOCITY

func move(delta):
	if facing == 1:
		anim_player.flip_h = true
		if splash:
			splash.flip_h = true
	velocity.x = HORIZ_VELOCITY * facing
	velocity.y += GRAVITY + GRAVITY_ACCEL

	GRAVITY_ACCEL += 10 * delta
	
	position += velocity * delta

func destroy():
	destroyed = true
	hitbox.desactivate()
	hurtbox.desactivate()
	anim_player.play("hit")

func on_anim_finished() -> void:
	if anim_player.animation == "hit":
		queue_free()
