extends Node
class_name Game

@export var player_scene: PackedScene = null
@export var spawn_area: SpawnArea = null
@export var power_up_display: PackedScene = preload("res://prefabs/power_up_display/power_up_display.tscn")

@onready var game_start: AudioStreamPlayer3D = $"../AudioManager/GameStart"

var timer_on: bool = false
var timer: float = 0.0
var player: CharacterBody3D = null
var mills: float = 0.0
var seconds: float = 0.0
var minutes: float = 0.0
var score: int = 0
var got_highscore: bool = false

@onready var power_up_state_manager: PowerUpStateManager = %PowerUpStateManager

@onready var hud: Control = %HUD
@onready var fail_container: Control = %FailContainer
@onready var timer_label: Label = %TimerLabel
@onready var best_time_label: Label = %BestTimeLabel
@onready var score_label: Label = %ScoreLabel
@onready var best_score_label: Label = %BestScoreLabel
@onready var power_ups_container: VBoxContainer = %PowerUpsContainer

@onready var camera_marker: Marker3D = %CameraPosition
@onready var player_marker: Marker3D = %PlayerPosition

@onready var level_manager: LevelManager = get_owner()

@onready var camera: Camera3D = get_viewport().get_camera_3d()

@onready var world: Node3D = get_child(0)
@onready var bcg: AudioStreamPlayer3D = $"../AudioManager/BCG"

var current_power_ups: Dictionary = {}

func _ready() -> void:
	if !level_manager.main_menu:
		start()
	else: 
		hud.visible = false
	
	fail_container.visible = false
	power_up_state_manager.power_up_added.connect(_on_power_up_added)
	power_up_state_manager.power_up_expire.connect(_on_power_up_removed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_timer(delta)
	var found_bubbles:Array[Node] = get_tree().get_nodes_in_group("bubbles")
	
	for bubble in found_bubbles:
		if !bubble.has_signal("bubble_bounce"):
			continue

		if !bubble.is_connected("bubble_bounce", _on_bubble_bounce):
			bubble.bubble_bounce.connect(_on_bubble_bounce)

func start() -> void:
	bcg.play()
	
	if !spawn_area:
		push_error("No spawn area assigned")
		return
	
	spawn_area.game_active = true
	power_up_state_manager.spawn_area = spawn_area

	if player_scene:
		player = player_scene.instantiate()
		player.process_mode = Node.PROCESS_MODE_DISABLED
		player.PUSM = power_up_state_manager
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
	
	best_score_label.text = "High-score: " + str(ScoreStorage.best_points)
	score_label.text = "Score: 0"

	await move_camera()
	if player: 
		player.process_mode = Node.PROCESS_MODE_INHERIT
	spawn_area.spawn_bubble()
	timer_on = true

func restart() -> void:
	game_start.play()
	await game_start.finished
	bcg.play()
	timer = 0.0
	if player: 
		player.process_mode = Node.PROCESS_MODE_INHERIT
	timer_label.text = "Current time: 00 : 00 : 000"
	if ScoreStorage.best_score.length() > 0:
		best_time_label.text = ScoreStorage.best_score
	else:
		best_time_label.text = "Best time: " + "00 : 00 : 000"
	best_score_label.text = "High-score: " + str(ScoreStorage.best_points)
	score_label.text = "Score: 0"
	score = 0
	timer_on = true
	hud.visible = true
	fail_container.visible = false
	player.global_position = player_marker.global_position
	spawn_area.game_active = true
	spawn_area.spawn_bubble()

func end() -> void:
	bcg.stop()
	if timer > ScoreStorage.best_timer:
		ScoreStorage.best_timer = timer
		ScoreStorage.best_score = "Best time: %02d : %02d : %03d" % [minutes, seconds, mills]
	got_highscore = score > ScoreStorage.best_points
	if got_highscore:
		ScoreStorage.best_points = score
	minutes = 0.0
	seconds = 0.0
	mills = 0.0
	timer_on = false
	hud.visible = false
	fail_container.visible = true
	if player:
		player.velocity = Vector3.ZERO
		player.process_mode = Node.PROCESS_MODE_DISABLED
	spawn_area.game_active = false
	power_up_state_manager.reset_power_ups()
	for powerup in get_tree().get_nodes_in_group("powerups"):
		powerup.queue_free()
	for power_up_display: Control in current_power_ups.values():
		power_up_display.queue_free()
	current_power_ups.clear()

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

func _on_bubble_bounce() -> void:
	score += 1
	score_label.text = "Score: " + str(score)

func _on_power_up_added(power_up: PowerUpStateManager.PowerUp) -> void:
	var spawn_instance: PowerUpDisplay = power_up_display.instantiate()
	spawn_instance.power_up = power_up
	power_ups_container.add_child.call_deferred(spawn_instance)
	current_power_ups[power_up] = spawn_instance

func _on_power_up_removed(power_up: PowerUpStateManager.PowerUp) -> void:
	var display: PowerUpDisplay = current_power_ups.get(power_up)
	if display:
		display.queue_free()
		current_power_ups.erase(power_up)
