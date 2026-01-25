extends Projectile
class_name SpiritSpit

@export var JUMP_VELOCITY := -180.0
@export var HORIZ_VELOCITY := 150.0
@export var GRAVITY := 10.0
@export var GRAVITY_ACCEL := 0.0

var facing := 1

var velocity := Vector2.ZERO

var vfx : PackedScene = load("res://scenes/short_lived_vfx.tscn")
var splash : ShortLivedVFX

func _ready() -> void:
	super._ready()
	
	splash = vfx.instantiate()
	splash.position = global_position
	get_tree().get_first_node_in_group("Level").add_child(splash)
	splash.play("spirit_splash")
	
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

func set_target(_target : LivingEntity):
	pass

func destroy():
	destroyed = true
	hitbox.desactivate()

	anim_player.play("hit")


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_player.animation == "hit":
		queue_free()
