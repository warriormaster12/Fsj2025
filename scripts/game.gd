extends Node
class_name Game

@export var player_scene: PackedScene = null
@export var spawn_area: SpawnArea = null

var timer_on: bool = false
var timer: float = 0.0
var player: CharacterBody3D = null
var mills: float = 0.0
var seconds: float = 0.0
var minutes: float = 0.0

@onready var hud: Control = %HUD
@onready var fail_container: Control = %FailContainer
@onready var timer_label: Label = %TimerLabel
@onready var best_time_label: Label = %BestTimeLabel

@onready var camera_marker: Marker3D = %CameraPosition
@onready var player_marker: Marker3D = %PlayerPosition

@onready var level_manager: LevelManager = get_owner()

@onready var camera: Camera3D = get_viewport().get_camera_3d()

@onready var world: Node3D = get_child(0)


func _ready() -> void:
	if !level_manager.main_menu:
		start()
	else: 
		hud.visible = false
	
	fail_container.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_timer(delta)


func start() -> void:
	if !spawn_area:
		push_error("No spawn area assigned")
		return
		
	%PowerUpStateManager.spawn_area = spawn_area

	if player_scene:
		player = player_scene.instantiate()
		player.process_mode = Node.PROCESS_MODE_DISABLED
		player.PUSM = %PowerUpStateManager
		world.add_child(player)
		player.global_position = player_marker.global_position
	else:
		push_warning("Player scene not defined")
	
	hud.visible = true
	
	timer_label.text = "Current time: 00 : 00 : 000"
	if ScoreStorage.best_score.length() > 0:
		best_time_label.text = "Best time: " + ScoreStorage.best_score
	else:
		best_time_label.text = "Best time: " + "00 : 00 : 000"

	await move_camera()
	if player: 
		player.process_mode = Node.PROCESS_MODE_INHERIT
	spawn_area.spawn_bubble()
	timer_on = true

func restart() -> void:
	timer = 0.0
	if player: 
		player.process_mode = Node.PROCESS_MODE_INHERIT
	timer_label.text = "Current time: 00 : 00 : 000"
	if ScoreStorage.best_score.length() > 0:
		best_time_label.text = ScoreStorage.best_score
	else:
		best_time_label.text = "Best time: " + "00 : 00 : 000"
	timer_on = true
	hud.visible = true
	fail_container.visible = false
	player.global_position = player_marker.global_position
	spawn_area.spawn_bubble()

func end() -> void:
	if timer > ScoreStorage.best_timer:
		ScoreStorage.best_timer = timer
		ScoreStorage.best_score = "Best time: %02d : %02d : %03d" % [minutes, seconds, mills]
	minutes = 0.0
	seconds = 0.0
	mills = 0.0
	timer_on = false
	hud.visible = false
	fail_container.visible = true
	if player:
		player.velocity = Vector3.ZERO
		player.process_mode = Node.PROCESS_MODE_DISABLED


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
	
	mills = fmod(timer, 1) * 1000
	seconds = fmod(timer, 60)
	minutes = fmod(timer, 60 * 60) / 60
	
	var text: String = "Current time: %02d : %02d : %03d" % [minutes, seconds, mills]
	timer_label.text = text
