extends PlayerState

@export var UP_VELOC = -250
@export var SIDE_VELOC = 250
@export var TICK_SIDE_VELOC = 100
@export var GINOURMOUS_SIDE_VELOC = 1000
@export var normal_timeout = 0.5
@export var tick_timeout = 0.2
@export var ginormous_timeout = 1.0

var timer = 0.0
var hit_direction := -1

enum HitType {
	TICK,
	NORMAL,
	GINORMOUS
}

var hit_type := HitType.NORMAL

func _ready() -> void:
	is_state_blocking = true

func enter():
	if hit_type == HitType.TICK:
		timer = tick_timeout
	elif hit_type == HitType.NORMAL:
		player.velocity.y = UP_VELOC
		timer = normal_timeout
	elif hit_type == HitType.GINORMOUS:
		player.velocity.y = UP_VELOC
		timer = ginormous_timeout
	player.direction = hit_direction * -1
	player.direct_sprite()
	player.move_and_slide()

	if hit_type == HitType.TICK:
		AnimPlayer.play("light_hit")
	else:
		AnimPlayer.play("hit")
 
func update(delta):
	timer -= delta
	if (timer <= 0 and player.is_on_floor()) or player.is_on_wall():
		transitioned.emit("idle")
	if hit_type == HitType.GINORMOUS:
		player.velocity.x = hit_direction * GINOURMOUS_SIDE_VELOC
	elif hit_type == HitType.TICK:
		player.velocity.x = hit_direction * TICK_SIDE_VELOC
	else:
		player.velocity.x = hit_direction * SIDE_VELOC
	player.handle_vertical_movement(player.get_gravity().y * delta)
	player.move_and_slide()

func exit():
	pass

# this function will be executed every time an animation ends,
# since most states end accordingly to an animation
func on_animation_end():
	pass
