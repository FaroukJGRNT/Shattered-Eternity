extends LivingEntity
class_name Enemy

@export var SPEED = 150.0
@export var ATTACK_RANGE = 40
@export var wander_distance = 200
@export var max_aggro_distance = 1000

var target
var direction
var can_attack = true

# Stats
func _init() -> void:
	max_life = 300
	life = max_life
	attack = 60
	defense = 2
	thunder_res = 2.0
	fire_res = 2.0
	ice_res = 2.0
	direction = facing

func _ready() -> void:
	elem_mode = ElemMode.NONE

func die():
	$Area2D.monitoring = false
	$HurtBox.monitoring = false
	$HurtBox.disabled = true
	for hitbox in $HitBoxes.get_children():
		if hitbox is HitBox:
			hitbox.monitoring = false
	$LifeBar.visible = false
	$EnemyStateMachine.on_state_transition("death")

func _physics_process(delta: float) -> void:
	var current_state : EnemyState = $EnemyStateMachine.get_current_state()

	if current_state.is_state_blocking:
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# make sure he faces the right direction
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$HitBoxes.scale.x = -1
		$HitBoxes.scale.y = 1
		facing = -1
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$HitBoxes.scale.x = 1
		$HitBoxes.scale.y = 1
		facing = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		$EnemyStateMachine.on_state_transition("chase")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$EnemyStateMachine.on_state_transition("wander")
		$EnemyStateMachine/Wander.wait_cooldown = 5.0
