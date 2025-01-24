extends CharacterBody3D

const HORIZONTAL_SPEED = 2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = -get_gravity()
		velocity.x = (randf() * 2 - 1) * HORIZONTAL_SPEED
		velocity.z = (randf() * 2 - 1) * HORIZONTAL_SPEED

	move_and_slide()
