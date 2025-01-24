extends Node
class_name Game


var timer_on: bool = false
var timer: float = 0.0

@onready var hud: Control = %HUD
@onready var timer_label: Label = %TimerLabel

@onready var level_manager: LevelManager = get_owner()

func _ready() -> void:
	if !level_manager.main_menu:
		start()
	else: 
		hud.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_timer(delta)


func start() -> void:
	timer_on = true
	hud.visible = true

func _update_timer(delta: float) -> void: 
	if !timer_on: 
		return
	
	timer += delta
	
	var mills: float = fmod(timer, 1) * 1000
	var seconds: float = fmod(timer, 60)
	var minutes: float = fmod(timer, 60 * 60) / 60
	
	var text: String = "Current time: %02d : %02d : %03d" % [minutes, seconds, mills]
	timer_label.text = text
