extends Node
class_name MainMenu

@export var camera_rotation_speed: float = 0.25

@onready var main_menu_ui: Control = %MainMenuUI
@onready var start_button: Button = %StartButton
@onready var instruct_button: Button = %Instructions
@onready var quit_button: Button = %QuitButton
@onready var menu_bcg: AudioStreamPlayer3D = $"../AudioManager/Menu_BCG"
@onready var game_start: AudioStreamPlayer3D = $"../AudioManager/GameStart"

@onready var camera_rotate: Node3D = $CameraRotate

@onready var level_manager: LevelManager = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_bcg.play()
	start_button.pressed.connect(_on_start_pressed)
	instruct_button.pressed.connect(_on_instruct_pressed)
	
	if OS.get_name() == "Web":
		quit_button.queue_free()
	else:
		quit_button.pressed.connect(_on_quit_pressed)


func _process(delta: float) -> void:
	camera_rotate.rotation.y -= camera_rotation_speed * delta
	

func _on_start_pressed() -> void:
	menu_bcg.stop()
	game_start.play()
	main_menu_ui.visible = false
	await game_start.finished
	level_manager.game.start()
	set_process(false)

func _on_instruct_pressed() -> void: 
	pass

func _on_quit_pressed() -> void:
	menu_bcg.stop()
	get_tree().quit()
