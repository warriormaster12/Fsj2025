extends Node

@export var bounce_stream: AudioStream = null
@export var pop_stream: AudioStream = null

var sfx_list: Array[AudioStreamPlayer3D] = []


func _process(_delta: float) -> void:
	for bubble in get_tree().get_nodes_in_group('bubbles'):
		if bubble.has_signal('bubble_destroy') && !bubble.is_connected('bubble_destroy', _on_bubble_destroy):
			bubble.connect('bubble_destroy', _on_bubble_destroy)
			
		if bubble.has_signal('bubble_bounce') && !bubble.is_connected('bubble_bounce', _on_bubble_bounce):
			bubble.connect('bubble_bounce', _on_bubble_bounce)
	
	var entires_to_remove: Array[int] = []
	for i in range(0, sfx_list.size()):
		var current_sfx: AudioStreamPlayer3D = sfx_list[i]
		
		if current_sfx == null:
			continue
		
		if !current_sfx.playing:
			current_sfx.queue_free()
			entires_to_remove.push_back(i)
	
	for i in entires_to_remove:
		sfx_list.remove_at(i)
			
			
			
func _on_bubble_destroy(position: Vector3) -> void:
	var pop_fx: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	pop_fx.stream = pop_stream
	pop_fx.bus = "Pop"
	pop_fx.pitch_scale = randf_range(0.8, 1.2)
	add_child(pop_fx)
	pop_fx.global_position = position
	pop_fx.play()
	sfx_list.append(pop_fx)

func _on_bubble_bounce(position: Vector3) -> void:
	var bounce_fx: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	bounce_fx.stream = bounce_stream
	bounce_fx.bus = "Bounce"
	bounce_fx.pitch_scale = randf_range(1.4, 1.7)
	add_child(bounce_fx)
	bounce_fx.global_position = position
	bounce_fx.play()
	sfx_list.append(bounce_fx)
