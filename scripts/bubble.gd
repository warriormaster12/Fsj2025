extends CharacterBody3D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = -get_gravity()
		velocity.x = randf() * 2 - 1
		velocity.z = randf() * 2 - 1

	move_and_slide()
