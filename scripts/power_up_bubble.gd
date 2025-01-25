extends CharacterBody3D

var simplex: FastNoiseLite = FastNoiseLite.new()
var lifetime: float = 0
var flip_vector: Vector2 = Vector2(1, 1)

func _physics_process(delta: float) -> void:
	velocity.x = simplex.get_noise_1d(lifetime) * flip_vector.x
	velocity.z = simplex.get_noise_1d(-lifetime) * flip_vector.y
	velocity = velocity.normalized()
	lifetime += delta * 5
	move_and_slide()
	if is_on_wall():
		var normal: Vector3 = get_wall_normal()
		if normal.x:
			flip_vector.x *= -1
		if normal.z:
			flip_vector.y *= -1
