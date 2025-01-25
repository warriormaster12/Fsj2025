extends CharacterBody3D

var PUSM: PowerUpStateManager = null

const SPEED = 16.0
const ACCELERATION = 24.0
const FRICTION = 12.0
const DASH_FORCE = 20.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_l", "move_r", "move_u", "move_d")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	if direction.length_squared() > 0.01:
		var speed_multiplier: float = PUSM.player_speed_multiplier
		velocity.x = move_toward(velocity.x, speed_multiplier * SPEED * direction.x, speed_multiplier * ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, speed_multiplier * SPEED * direction.z, speed_multiplier * ACCELERATION * delta)
		if Input.is_action_just_pressed("dash"):
			velocity.x = direction.x * DASH_FORCE
			velocity.z = direction.z * DASH_FORCE

	move_and_slide()
