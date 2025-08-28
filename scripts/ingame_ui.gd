extends CanvasLayer

@export var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LifeBar.max_value = player.max_life


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$LifeBar.value = player.life
