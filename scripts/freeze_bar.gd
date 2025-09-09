extends TextureProgressBar

func _ready() -> void:
	$TextureProgressBar.show_behind_parent = true
	scale = Vector2(0.35, 0.35)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TextureProgressBar.max_value = max_value
	$TextureProgressBar.value = value
