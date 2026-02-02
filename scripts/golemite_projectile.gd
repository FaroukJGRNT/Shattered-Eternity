extends ProjectileTemplate

var spawned := false
var speed := 200.0
var max_speed := 700.0
var accel := 30.5
var direction := Vector2(1, 0)

func _ready() -> void:
	super._ready()
	hurtbox.desactivate()
	hitbox.desactivate()
	anim_player.play("spawn")

func move(delta):
	if spawned:
		position += speed * direction * delta
		speed = min(speed + accel, max_speed)

func on_anim_finished():
	if anim_player.animation == "spawn":
		spawned = true
		anim_player.play("go")
	if anim_player.animation == "destroy":
		queue_free()

func on_frame_changed():
	if anim_player.animation == "spawn" and anim_player.frame >= 6:
		hurtbox.activate()
		hitbox.activate()

func destroy():
	destroyed = true
	hitbox.desactivate()
	if hurtbox:
		hurtbox.desactivate()

	anim_player.play("destroy")
