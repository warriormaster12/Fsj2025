extends CharacterBody3D

signal power_up_destroy()
signal power_up_pickup()

const TIME_TO_LIVE: float = 5
const FALL_SPEED: float = 1

var simplex: FastNoiseLite = FastNoiseLite.new()
var lifetime: float = 0
var flip_vector: Vector2 = Vector2(1, 1)

var PUSM: PowerUpStateManager = null

func _physics_process(delta: float) -> void:
	velocity.x = simplex.get_noise_1d(5 * lifetime) * flip_vector.x
	velocity.y = -FALL_SPEED
	velocity.z = simplex.get_noise_1d(-5 * lifetime) * flip_vector.y
	velocity = velocity.normalized()
	lifetime += delta
	var pv: Vector3 = velocity
	move_and_slide()
	if is_on_wall():
		velocity = pv
		var normal: Vector3 = get_wall_normal()
		if normal.x:
			flip_vector.x *= -1
		if normal.z:
			flip_vector.y *= -1

	var collision: KinematicCollision3D = get_last_slide_collision()
	if collision:
		if collision.get_collider().is_in_group("player"):
			PUSM.activate_random_power_up(position)
			power_up_pickup.emit()
			queue_free()
		elif is_on_floor():
			power_up_destroy.emit()
			queue_free()
