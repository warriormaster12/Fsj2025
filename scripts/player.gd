extends CharacterBody3D


const SPEED = 16.0
const ACCELERATION = 24.0
const FRICTION = 12.0
const DASH_FORCE = 20.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_l", "move_r", "move_u", "move_d")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.length_squared() > 0.01:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
		if Input.is_action_just_pressed("dash"):
			velocity.x = direction.x * DASH_FORCE
			velocity.z = direction.z * DASH_FORCE
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)

	move_and_slide()
