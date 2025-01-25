extends CharacterBody3D

var PUSM: PowerUpStateManager = null

const SPEED = 16.0
const ACCELERATION = 24.0
const SLOWDOWN_ACCELERATION = 6.0
const FRICTION = 12.0
const DASH_FORCE = 20.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_l", "move_r", "move_u", "move_d")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	var speed_multiplier: float = PUSM.player_speed_multiplier
	if Input.is_action_just_pressed("dash"):
		velocity.x = direction.x * DASH_FORCE
		velocity.z = direction.z * DASH_FORCE
	else:
		if abs(direction.x) > 0.001:
			var acceleration_x: float = ACCELERATION if signf(-velocity.x) != signf(direction.x) else SLOWDOWN_ACCELERATION
			velocity.x = move_toward(velocity.x, speed_multiplier * SPEED * direction.x, speed_multiplier * acceleration_x * delta)
		if abs(direction.z) > 0.001:
			var acceleration_z: float = ACCELERATION if signf(-velocity.z) != signf(direction.z) else SLOWDOWN_ACCELERATION
			velocity.z = move_toward(velocity.z, speed_multiplier * SPEED * direction.z, speed_multiplier * acceleration_z * delta)

	move_and_slide()
	if is_on_wall():
		var normal: Vector3 = get_wall_normal()
		if signf(-normal.x) == signf(velocity.x):
			velocity.x = 0
		if signf(-normal.z) == signf(velocity.z):
			velocity.z = 0
