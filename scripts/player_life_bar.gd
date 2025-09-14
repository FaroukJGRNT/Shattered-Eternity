extends TextureProgressBar

# This lifebar works in a really weird way
# It is composed of the middle texture of the bar, and 2 sprites each for
# one edge of the bar. We did it this way to be able to have a longer
# health bar like in dark souls when you level up vitality
# Each time the health bar grows of n pixels, the right sprite of the edge has to move n pixels
# to the right
# May god forgive me

# Let's try to have 1px per hp
# That means if our player has 100hp, the bar will be 100px long
# And if he gains 20 more max hp, then then the bar will become 120px long and
# we will need to move the right sprite by 20px to the right
# Lets use the left sprite as reference

func update_max_value(new_max):
	size.x = new_max
	max_value = new_max
	$HealthBarRight.position.x = $HealthBarLeft.position.x + new_max
	$TextureProgressBar.max_value = new_max
	$TextureProgressBar.size.x += (new_max - $TextureProgressBar.size.x)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TextureProgressBar.max_value = max_value
	$TextureProgressBar.value = value
