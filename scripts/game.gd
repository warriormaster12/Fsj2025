extends Node
class_name Game


var timer_on: bool = false
var timer: float = 0.0

@onready var hud: Control = %HUD
@onready var timer_label: Label = %TimerLabel

@onready var camera_marker: Marker3D = %CameraPosition

@onready var level_manager: LevelManager = get_owner()

@onready var camera: Camera3D = get_viewport().get_camera_3d()

@onready var world: Node3D = get_child(0)

func _ready() -> void:
	if !level_manager.main_menu:
		start()
	else: 
		hud.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_timer(delta)


func start() -> void:
	hud.visible = true
	await move_camera()
	timer_on = true

func move_camera() -> void:
	camera.reparent(world)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(camera, "global_position", camera_marker.global_position, 2.0)
	tween.tween_property(camera, "global_rotation", camera_marker.global_rotation, 2.0)
	tween.set_trans(Tween.TRANS_BOUNCE)
	
	await tween.finished

func _update_timer(delta: float) -> void: 
	if !timer_on: 
		return
	
	timer += delta
	
	var mills: float = fmod(timer, 1) * 1000
	var seconds: float = fmod(timer, 60)
	var minutes: float = fmod(timer, 60 * 60) / 60
	
	var text: String = "Current time: %02d : %02d : %03d" % [minutes, seconds, mills]
	timer_label.text = text
