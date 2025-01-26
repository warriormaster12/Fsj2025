extends Control
class_name PowerUpDisplay

@onready var progress_bar: ProgressBar = %ProgressBar

var power_up: PowerUpStateManager.PowerUp = null

func _process(delta: float) -> void:
	progress_bar.max_value = power_up.initial_duration
	progress_bar.value = power_up.duration
