extends Control

@onready var restart_button: Button = $Container/HBoxContainer/RestartButton
@onready var main_menu_button: Button = $Container/HBoxContainer/MainMenuButton

@onready var game: Game = get_owner().game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_button.pressed.connect(_restart_pressed)
	main_menu_button.pressed.connect(_main_menu_pressed)


func _restart_pressed() -> void: 
	game.restart()

func _main_menu_pressed() -> void: 
	pass
