extends HBoxContainer
class_name PowerUpDisplay

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var icon: TextureRect = %Icon

var power_up: PowerUpStateManager.PowerUp = null

func _ready() -> void:
	match power_up.type:
		PowerUpStateManager.PowerUpType.PLAYER_SPEEDUP:
			icon.texture = load("res://resources/images/textures/speedboost_static.png")
		PowerUpStateManager.PowerUpType.TIME_SLOWDOWN:
			icon.texture = load("res://resources/images/textures/timebendboost_static.png")

func _process(_delta: float) -> void:
	progress_bar.max_value = power_up.initial_duration
	progress_bar.value = power_up.duration
