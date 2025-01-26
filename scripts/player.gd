extends CharacterBody3D
class_name PlayerController

var PUSM: PowerUpStateManager = null

const EXCESS_SPEED_RATE = 2
const MAX_SPEED = 8.0
const ACCELERATION = 20.0
const SLOWDOWN_ACCELERATION = 6.0
const FRICTION = 12.0
const DASH_FORCE = 20.0
const DASH_RECHARGE_TIME = 0.1
const DASH_COUNT_MAX = 999999999

var dash_count: int = DASH_COUNT_MAX
var dash_recharge_cooldown: float = DASH_RECHARGE_TIME
var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if dash_count < DASH_COUNT_MAX:
		dash_recharge_cooldown -= delta
		if dash_recharge_cooldown < 0:
			dash_count += 1
			dash_recharge_cooldown = DASH_RECHARGE_TIME

	var input_dir := Input.get_vector("move_l", "move_r", "move_u", "move_d")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
	var speed_multiplier: float = PUSM.player_speed_multiplier if PUSM else 1.0
	if Input.is_action_just_pressed("dash") && dash_count > 0:
		velocity.x = direction.x * DASH_FORCE
		velocity.z = direction.z * DASH_FORCE
		dash_count -= 1
	else:
		if abs(direction.x) > 0.001:
			var acceleration_x: float = ACCELERATION if signf(-velocity.x) != signf(direction.x) else SLOWDOWN_ACCELERATION
			velocity.x = move_toward(velocity.x, speed_multiplier * MAX_SPEED * direction.x, speed_multiplier * acceleration_x * delta)
		if abs(direction.z) > 0.001:
			var acceleration_z: float = ACCELERATION if signf(-velocity.z) != signf(direction.z) else SLOWDOWN_ACCELERATION
			velocity.z = move_toward(velocity.z, speed_multiplier * MAX_SPEED * direction.z, speed_multiplier * acceleration_z * delta)
		var velocity_length: float = velocity.length()
		if velocity_length > MAX_SPEED:
			velocity *= move_toward(velocity_length, MAX_SPEED, EXCESS_SPEED_RATE * delta) / velocity_length

	move_and_slide()
	if is_on_wall():
		var normal: Vector3 = get_wall_normal()
		if abs(normal.x) > 0.001 && signf(-normal.x) == signf(velocity.x):
			velocity.x = 0
		if abs(normal.z) > 0.001 && signf(-normal.z) == signf(velocity.z):
			velocity.z = 0
