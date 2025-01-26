extends Node3D

@onready var player: PlayerController = get_owner()
@onready var body: AnimatedSprite3D = $Body
@onready var eyes: AnimatedSprite3D = $Eyes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func manage_eyes(direction: Vector3) -> void:
	pass

func manage_body(direction: Vector3) -> void:
	if direction.length() > 0.0:
		if abs(direction.x) == 1.0:
			body.play("run")
		else:
			body.play("idle")
		body.flip_h = true if direction.x == 1.0 else false
	else: 
		body.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction: Vector3 = player.direction
	manage_body(direction)
	manage_eyes(direction)
