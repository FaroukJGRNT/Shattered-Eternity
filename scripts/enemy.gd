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
var shader_duration = 0.2
var shader_on_cooldown = false

# Stats
func _init() -> void:
	max_life = 300
	life = max_life
	attack = 30
	defense = 10
 
func take_damage(dmg:int):
	damage_taken.emit()
	super.take_damage(dmg)
	$AnimatedSprite2D.material.set_shader_parameter("enabled", true)
	frame_freeze(1, 0.07)
	shader_on_cooldown = true
	shader_duration = 0.2

func die():
	$Area2D.monitoring = false
	if HurtBox:
		$HurtBox.queue_free()
	$LifeBar.visible = false
	$EnemyStateMachine.on_state_transition("death")

func _physics_process(delta: float) -> void:
	if shader_on_cooldown:
		shader_duration -= delta
		if shader_duration <= 0:
			shader_on_cooldown = false
			$AnimatedSprite2D.material.set_shader_parameter("enabled", false)
	update_health_bar()
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

func update_health_bar():
	$LifeBar.max_value = max_life
	$LifeBar.value = life

func frame_freeze(timeScale, duration):
	Engine.time_scale = 0
	await(get_tree().create_timer(duration, true, false, true).timeout)
	Engine.time_scale = 1
