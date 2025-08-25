extends CharacterBody2D

const SPEED = 150.0

enum Activity {
	CHILLIN,
	ATAK
}

enum State {
	IDLE,
	RUNNING
}

var state = State.IDLE
var activity = Activity.CHILLIN
var target
var direction

func _physics_process(delta: float) -> void:
	if velocity.x != 0:
		state = State.RUNNING
	else:
		state = State.IDLE
		
	
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
		
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Aggro on")
		activity = Activity.ATAK
		target = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Aggro off")
		activity = Activity.CHILLIN
		velocity = Vector2(0, 0)
