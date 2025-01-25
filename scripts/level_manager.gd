extends Node
class_name LevelManager


@export var main_menu: MainMenu = null
@export var game: Game = null

var bubbles: Array[CharacterBody3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for bubble in get_tree().get_nodes_in_group("bubbles"):
		if bubble.has_signal("bubble_destroy"):
			bubbles.push_back(bubble)
	
	for bubble in bubbles: 
		bubble.bubble_destroy.connect(_on_bubble_destroyed)


func _on_bubble_destroyed() -> void:
	if game:
		game.end()
	for bubble in bubbles:
		bubble.bubble_destroy.disconnect(_on_bubble_destroyed)
