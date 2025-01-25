extends CharacterBody3D

signal bubble_destroy()

const HORIZONTAL_SPEED = 2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		var player_delta: Vector3 = position - %Player.position
		var direction: Vector3 = player_delta.clamp(Vector3(-1, 0, -1), Vector3(1, 0, 1))
		direction = 0.75 * direction + 0.25 * Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
		velocity = -get_gravity() * 0.5 + 4 * direction

	if position.y < 1 || is_on_wall():
		bubble_destroy.emit()
		queue_free()

	move_and_slide()
