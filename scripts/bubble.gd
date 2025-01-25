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
		direction = 0.75 * direction + 0.25 * Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
		velocity = -get_gravity() * 0.5 + 4 * direction

	move_and_slide()
	
	if position.y < 1 || is_on_wall():
		bubble_destroy.emit()
		queue_free()
