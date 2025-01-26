extends Node3D

@onready var player: PlayerController = get_owner()
@onready var body_anim_tree: AnimationTree = $BodyAnimationTree
@onready var eyes_anim_tree: AnimationTree = $EyesAnimTree
@onready var eyes: Sprite3D = $Eyes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


func manage_eyes(direction: Vector3) -> void:
	eyes.flip_h = sign(direction.x) == 1 
	var running: bool = ceilf(direction.x) == 1.0
	eyes_anim_tree.set("parameters/idle_run/blend_amount", abs(direction.x))
	if running:
		eyes.set("parameters/run_eyes/blend_position", -direction.x if eyes.flip_h else direction.x)

func manage_body(direction: Vector3) -> void:
	body_anim_tree.set("parameters/idle_run/blend_position", direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction: Vector3 = player.direction
	manage_body(direction)
	manage_eyes(direction)
