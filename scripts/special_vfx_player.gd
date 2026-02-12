extends AnimatedSprite2D
class_name SpecialVFXPlayer

@export var base_x := 3.0
@export var base_y := 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("animation_finished", on_animation_finished)
	visible = false

func play_vfx(anim_name):
	visible = true
	if is_playing():
		stop()
	play(anim_name)

func on_animation_finished():
	visible = false
	rotation_degrees = 0
	position.x = base_x
	position.y = base_y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
