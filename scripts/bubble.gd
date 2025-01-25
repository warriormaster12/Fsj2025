extends CharacterBody3D

signal bubble_destroy()
signal bubble_bounce()

const HORIZONTAL_SPEED = 2

var player: CharacterBody3D = null

func _ready() -> void:
	velocity.y = 5.0

func _process(_delta: float) -> void:
	if !player:
		player = get_tree().get_nodes_in_group("player")[0]
		set_process(false)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		bubble_bounce.emit()
		var player_delta: Vector3 = position - player.position
		var direction: Vector3 = player_delta.clamp(Vector3(-1, 0, -1), Vector3(1, 0, 1))
		direction = 0.5 * direction + 1 * Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
		velocity = -get_gravity() * randf_range(0.75, 1.0) + 4 * direction

	move_and_slide()

	if is_on_wall():
		var wall: Vector3 = get_wall_normal()
		if wall.x:
			velocity.x *= -1
		if wall.z:
			velocity.z *= -1
	
	var collision: KinematicCollision3D = get_last_slide_collision()
	if collision && is_on_floor() && !collision.get_collider().is_in_group("player"):
		bubble_destroy.emit()
		queue_free()
