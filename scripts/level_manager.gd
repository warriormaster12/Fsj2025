extends Node
class_name LevelManager


@export var main_menu: MainMenu = null
@export var game: Game = null

var bubble_count: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var found_bubbles:Array[Node] = get_tree().get_nodes_in_group("bubbles")
	bubble_count = found_bubbles.size()
	
	for bubble in found_bubbles:
		if !bubble.has_signal("bubble_destroy"):
			continue

		if !bubble.is_connected("bubble_destroy", _on_bubble_destroyed):
			bubble.bubble_destroy.connect(_on_bubble_destroyed)

func _on_bubble_destroyed(_position: Vector3) -> void:
	bubble_count = clampi(bubble_count -1, 0, bubble_count)
	if game && bubble_count == 0:
		game.end()
