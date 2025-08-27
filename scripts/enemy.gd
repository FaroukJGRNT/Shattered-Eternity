extends LivingEntity

const SPEED = 150.0

enum Activity {
	CHILLIN,
	ATAK
}

enum State {
	IDLE,
	RUNNING,
	ATTACK
}

var state = State.IDLE
var activity = Activity.CHILLIN
var target
var direction
var can_attack = true

func _physics_process(delta: float) -> void:
	if state == State.ATTACK:
		return
	
	if velocity.x != 0:
		state = State.RUNNING
	else:
		state = State.IDLE
		
	if target and abs(target.position.x - position.x) <= 30 and can_attack:
		print("ATTACKING")
		state = State.ATTACK
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if activity == Activity.ATAK:
		direction = (target.position - position).normalized()
		velocity.x = SPEED * direction.x

	# make sure he faces the right direction
	if velocity.x <  0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		
	# play the correct animation
	if state == State.IDLE:
		$AnimatedSprite2D.play("idle")
	if state == State.RUNNING:
		$AnimatedSprite2D.play("run")
	if state == State.ATTACK:
		$AnimatedSprite2D.play("attack")
		
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		activity = Activity.ATAK
		target = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		activity = Activity.CHILLIN
		velocity = Vector2(0, 0)

func _on_animated_sprite_2d_animation_finished() -> void:
	if state == State.ATTACK:
		state = State.IDLE
		$AttackCoolDown.start()
		can_attack = false

func _on_attack_cool_down_timeout() -> void:
	can_attack = true
