extends Node

@onready var bounce_sfx: AudioStreamPlayer3D = $BounceSFX
@onready var pop_sfx: AudioStreamPlayer3D = $PopSFX


func _process(_delta: float) -> void:
	for bubble in get_tree().get_nodes_in_group('bubbles'):
		if bubble.has_signal('bubble_destroy') && !bubble.is_connected('bubble_destroy', _on_bubble_destroy):
			bubble.connect('bubble_destroy', _on_bubble_destroy)
			
		if bubble.has_signal('bubble_bounce') && !bubble.is_connected('bubble_bounce', _on_bubble_bounce):
			bubble.connect('bubble_bounce', _on_bubble_bounce)
			
			
			
func _on_bubble_destroy() -> void:
	pop_sfx.play()

func _on_bubble_bounce() -> void:
	bounce_sfx.play()
