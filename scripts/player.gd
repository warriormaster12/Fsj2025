extends CharacterBody3D


const SPEED = 600.0
const FRICTION = 12.0


func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_l", "move_r", "move_u", "move_d")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.length_squared() > 0.01:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, FRICTION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, FRICTION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)

	move_and_slide()
