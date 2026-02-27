extends CanvasLayer

@export var player : Player
var camera : Camera2D

@export var scale_factor := 0.08
var rect : ColorRect
var dot : ColorRect

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	if player:
		$LifeBar2.max_value = player.max_life
	camera = get_tree().get_first_node_in_group("Camera")

	rect = ColorRect.new()

	rect.color = Color(0, 1, 0, 0.2)
	rect.anchor_left = 1
	rect.anchor_right = 1
	rect.anchor_top = 0
	rect.anchor_bottom = 0
	add_child(rect)
	
	rect.visible = false
	
	dot = ColorRect.new()
	dot.color = Color.RED
	dot.size = Vector2(32 * scale_factor, 32 * scale_factor)
	rect.add_child(dot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		$LifeBar2.value = player.life
		$ProgressBar.value = player.mana
		$ProgressBar.max_value = player.max_mana
		$TextureProgressBar.max_value = player.max_resonance_value
		$TextureProgressBar.value = player.resonance_value
		$Label.text = str(player.mana_echoes)

	if not camera:
		return

	var width = (camera.limit_right - camera.limit_left) * scale_factor
	var height = (camera.limit_bottom - camera.limit_top) * scale_factor


	rect.custom_minimum_size = Vector2(width, height)
	rect.size = Vector2(width, height)

	rect.offset_left = -width - 20
	rect.offset_top = 20
	rect.offset_right = -20
	rect.offset_bottom = 20 + height

	var px = player.global_position.x - camera.limit_left
	var py = player.global_position.y - camera.limit_top

	var mini_x = px / (camera.limit_right - camera.limit_left) * width
	var mini_y = py / (camera.limit_bottom - camera.limit_top) * height

	dot.position.x = mini_x
	dot.position.y = mini_y
	
