extends CharacterBody3D

signal bubble_destroy()
signal bubble_bounce()

const HORIZONTAL_SPEED = 2
const GRAVITY: float = 5
const BOUNCE_STRENGTH_MIN: float = 5
const BOUNCE_STRENGTH_MAX: float = 6

var player: CharacterBody3D = null

func _ready() -> void:
	velocity.y = 5.0

func _process(_delta: float) -> void:
	if !player:
		player = get_tree().get_nodes_in_group("player")[0]
		set_process(false)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3.DOWN * GRAVITY * delta
	else:
		bubble_bounce.emit()
		var player_delta: Vector3 = position - player.position
		var direction: Vector3 = player_delta
		if direction.length_squared() > 1:
			direction /= direction.length()
		direction = 0.5 * direction + 1 * Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
		velocity = Vector3.UP * randf_range(BOUNCE_STRENGTH_MIN, BOUNCE_STRENGTH_MAX) + 4 * direction

	# Save our velocity since move_and_slide nicely sets it to zero on wall collision
	var pv: Vector3 = velocity
	move_and_slide()

	if is_on_wall():
		velocity = pv
		var wall: Vector3 = get_wall_normal()
		if absf(wall.x) > 0.001:
			velocity.x *= -0.2
		if absf(wall.z) > 0.001:
			velocity.z *= -0.2

	var collision: KinematicCollision3D = get_last_slide_collision()
	if collision && is_on_floor() && !collision.get_collider().is_in_group("player"):
		bubble_destroy.emit()
		queue_free()
