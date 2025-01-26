extends Control

@onready var restart_button: Button = $Container/HBoxContainer/RestartButton
@onready var main_menu_button: Button = $Container/HBoxContainer/MainMenuButton
@onready var result_label: Label = $Container/ResultLabel
@onready var game: Game = get_owner().game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_button.pressed.connect(_restart_pressed)
	main_menu_button.pressed.connect(_main_menu_pressed)
	visibility_changed.connect(_visibility_changed)

func _visibility_changed() -> void:
	if visible: 
		var text: String = game.timer_label.text + "\n" + ScoreStorage.best_score
		if game.got_highscore:
			text += "\nNEW HIGH-SCORE"
		text += "\n" + game.score_label.text
		if not game.got_highscore:
			text += "\n" + game.best_score_label.text
		result_label.text = text


func _restart_pressed() -> void: 
	game.restart()

func _main_menu_pressed() -> void: 
	var tween: Tween = create_tween()
	var color_rect: ColorRect = get_parent().get_parent().color_rect
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	tween.tween_property(color_rect, "color:a", 1.0, 1.0).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	await get_tree().create_timer(1,0).timeout
	get_tree().reload_current_scene()
