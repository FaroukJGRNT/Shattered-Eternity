extends HurtBox

func _ready() -> void:
	super._ready()
	monitoring = false
	disabled = true

func on_area_entered(area: Area2D) -> void:
	if area == null:
		return

	if area is HitBox:
		return
