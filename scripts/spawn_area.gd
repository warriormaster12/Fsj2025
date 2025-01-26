extends Node3D
class_name SpawnArea

const POWER_UP_INTERVAL_MIN: float = 5
const POWER_UP_INTERVAL_MAX: float = 20

var game_active: bool = false

@export var spawn_objects: Array[PackedScene] = [
	preload("res://prefabs/bubble/bubble.tscn"),
	preload("res://prefabs/bubble/powerup.tscn"),
]
var box_extent: Vector3 = Vector3.ZERO

var time_till_next_power_up: float = POWER_UP_INTERVAL_MIN

func _ready() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			var instance: MeshInstance3D = child
			if instance.mesh is BoxMesh:
				var box:BoxMesh = instance.mesh
				box_extent = box.size * 0.5
				instance.queue_free()
				break

func _process(delta: float) -> void:
	if !game_active:
		return
	time_till_next_power_up -= delta
	if time_till_next_power_up < 0:
		spawn_power_up()
		time_till_next_power_up = randf_range(POWER_UP_INTERVAL_MIN, POWER_UP_INTERVAL_MAX)

func spawn_bubble() -> void:
	var spawn_instance: Node3D = spawn_objects[0].instantiate()
	get_parent().add_child.call_deferred(spawn_instance)
	spawn_instance.position = get_random_position()

func spawn_power_up() -> void:
	var spawn_instance: Node3D = spawn_objects[1].instantiate()
	get_parent().add_child.call_deferred(spawn_instance)
	spawn_instance.PUSM = %PowerUpStateManager
	spawn_instance.position = get_random_position()

func get_random_position() -> Vector3:
	var calculated_pos: Vector3 = Vector3(
		randf_range(-box_extent.x, box_extent.x),
		randf_range(-box_extent.y, box_extent.y),
		randf_range(-box_extent.z, box_extent.z)
	)

	return calculated_pos + global_position
