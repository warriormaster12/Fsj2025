extends Node
class_name PowerUpStateManager

@onready var PowerUpsLabel: Label = %PowerUpsLabel

enum PowerUpType {
	PLAYER_SPEEDUP,
	TIME_SLOWDOWN,
}

class PowerUp:
	var type: PowerUpType
	var duration: float

	func _init(type_: PowerUpType, duration_: float) -> void:
		type = type_
		duration = duration_

var active_power_ups: Array[PowerUp] = []
var player_speed_multiplier: float = 1

func _process(_delta: float) -> void:
	var text: String = ""
	for power_up in active_power_ups:
		text += "{0} {1}s\n".format([power_up.type, power_up.duration])
	text += "psm = {0}\n".format([player_speed_multiplier])
	text += "gts = {0}\n".format([Engine.time_scale])
	PowerUpsLabel.text = text

func _physics_process(delta: float) -> void:
	if Engine.time_scale < 0.01:
		delta = 0
	else:
		delta = delta / Engine.time_scale

	player_speed_multiplier = 1
	var time_scale: float = 1
	for i in range(len(active_power_ups) -1, -1, -1):
		var power_up: PowerUp = active_power_ups[i]
		power_up.duration -= delta
		if power_up.duration < 0:
			active_power_ups.remove_at(i)
			continue
		match power_up.type:
			PowerUpType.PLAYER_SPEEDUP:
				player_speed_multiplier *= 1.5
			PowerUpType.TIME_SLOWDOWN:
				time_scale *= 0.5
	Engine.time_scale = time_scale
