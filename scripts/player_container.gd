extends Node3D
class_name PlayerContainer

var original_positions: Array[Vector3] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Node3D:
			var node: Node3D = child
			original_positions.push_back(node.position)

func reset_positions() -> void:
	for i in get_child_count():
		var child: Node = get_child(i)
		if child is Node3D:
			var node: Node3D = child
			node.position = original_positions[i]
