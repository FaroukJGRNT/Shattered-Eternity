extends LivingEntity
class_name Enemy

@export var SPEED = 150.0
@export var ATTACK_RANGE = 40
@export var wander_distance = 200
@export var max_aggro_distance = 1000
signal damage_taken

var target
var direction
var can_attack = true
var facing = 1


# Stats
func _init() -> void:
	max_life = 300
	life = max_life
	attack = 60
	defense = 5
	thunder_res = 10.0
	fire_res = 10.0
	ice_res = 10.0

func _ready() -> void:
	pass 
func take_damage(dmg:DamageContainer):
	dmg = super.take_damage(dmg)
	damage_taken.emit(dmg)

func die():
	Engine.time_scale = 1
	$Area2D.monitoring = false
	if $CollisionShape2D:
		$CollisionShape2D.queue_free()
	if $HurtBox:
		$HurtBox.queue_free()
	$LifeBar.visible = false
	$EnemyStateMachine.on_state_transition("death")

func _physics_process(delta: float) -> void:
	var current_state_name = $EnemyStateMachine.get_current_state().name
	if current_state_name == "Attack" or current_state_name == "Death":
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# make sure he faces the right direction
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$HitBox.scale.x = -1
		$HitBox.scale.y = 1
		facing = -1
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$HitBox.scale.x = 1
		$HitBox.scale.y = 1
		facing = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		$EnemyStateMachine.on_state_transition("chase")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$EnemyStateMachine.on_state_transition("wander")
		$EnemyStateMachine/Wander.wait_cooldown = 5.0
