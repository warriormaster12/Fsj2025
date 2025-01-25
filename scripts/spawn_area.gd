extends Node3D
class_name SpawnArea

@export var spawn_objects: Array[PackedScene] = [preload("res://prefabs/bubble/bubble.tscn")]
var box_extent: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			var instance: MeshInstance3D = child
			if instance.mesh is BoxMesh:
				var box:BoxMesh = instance.mesh
				box_extent = box.size * 0.5
				instance.queue_free()
				break


func spawn() -> void:
	var spawn_instance: Node3D = spawn_objects[0].instantiate()
	get_parent().add_child.call_deferred(spawn_instance)

	spawn_instance.position = get_random_position()
		



func get_random_position() -> Vector3:
	var calculated_pos: Vector3 = Vector3(
		randf_range(-box_extent.x, box_extent.x),
		randf_range(-box_extent.y, box_extent.y),
		randf_range(-box_extent.z, box_extent.z)
	)
	
	return calculated_pos + global_position
