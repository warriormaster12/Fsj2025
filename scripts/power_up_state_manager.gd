extends Node
class_name PowerUpStateManager

signal power_up_added(power_up: PowerUp);
signal power_up_expire(power_up: PowerUp);

enum PowerUpType {
	PLAYER_SPEEDUP,
	TIME_SLOWDOWN,
	BUBBLES,
}

class PowerUp:
	var type: PowerUpType
	var duration: float
	var initial_duration: float

	func _init(type_: PowerUpType, duration_: float) -> void:
		type = type_
		duration = duration_
		initial_duration = duration_

var spawn_area: SpawnArea = null
var active_power_ups: Array[PowerUp] = []
var player_speed_multiplier: float = 1

func reset_power_ups() -> void:
	active_power_ups.clear()

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
			power_up_expire.emit(power_up)
			active_power_ups.remove_at(i)
			continue
		match power_up.type:
			PowerUpType.PLAYER_SPEEDUP:
				player_speed_multiplier *= 1.5
			PowerUpType.TIME_SLOWDOWN:
				time_scale *= 0.5
	Engine.time_scale = time_scale

func activate_random_power_up() -> void:
	var type: PowerUpType = PowerUpType.values()[randi() % PowerUpType.size()]
	if type == PowerUpType.BUBBLES:
		for i in range(0, randi() % 5 + 1):
			spawn_area.spawn_bubble()
			await get_tree().create_timer(0.5).timeout
	else:
		var power_up: PowerUp = PowerUp.new(type, 10)
		active_power_ups.append(power_up)
		power_up_added.emit(power_up)
	
