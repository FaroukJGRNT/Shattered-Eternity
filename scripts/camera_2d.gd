@tool
extends Camera2D

var shake_str : float = 0.0
var fade: float = 10.0
var map : TileMapLayer
@export var sky_height := 300
@export var horiz_border_blocks := 4
var used_rect : Rect2i

func _ready() -> void:
	await get_tree().process_frame
	
	map = get_tree().get_first_node_in_group("TileMaps")
	setup_cam_limits()

func setup_cam_limits():
	if not map:
		return
	
	used_rect = map.get_used_rect()
	var tile_map_size := map.tile_set.tile_size
	
	limit_left = (used_rect.position.x * tile_map_size.x) + (horiz_border_blocks * tile_map_size.x)
	limit_top = (used_rect.position.y * tile_map_size.y) - sky_height
	limit_right = ((used_rect.position.x + used_rect.size.x) *  tile_map_size.x) - (horiz_border_blocks * tile_map_size.x)
	limit_bottom = (used_rect.position.y + used_rect.size.y) *  tile_map_size.y

func trigger_shake(max_shake: float, _fade: float = fade):
	shake_str = max_shake
	fade =  _fade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_str > 0.0:
		shake_str = lerp(shake_str, 0.0, fade * delta)
		offset = Vector2(randf_range(-shake_str, shake_str), randf_range(-shake_str, shake_str))
	else:
		offset = Vector2(0, 0)
	
	queue_redraw()
	
func _draw():
	if not Engine.is_editor_hint():
		return
	
	var rect = Rect2(
		Vector2(limit_left, limit_top),
		Vector2(limit_right - limit_left, limit_bottom - limit_top)
	)
	
	rect.position -= global_position
	
	draw_rect(rect, Color(0,1,0,0.6), false, 3)
