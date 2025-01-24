extends Node
class_name MainMenu

@onready var main_menu_ui: Control = $MainMenuUI
@onready var start_button: Button = %StartButton
@onready var instruct_button: Button = %Instructions
@onready var quit_button: Button = %QuitButton

@onready var level_manager: LevelManager = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	instruct_button.pressed.connect(_on_instruct_pressed)
	quit_button.pressed.connect(_on_quit_pressed)



func _on_start_pressed() -> void:
	main_menu_ui.visible = false
	level_manager.game.start()

func _on_instruct_pressed() -> void: 
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
