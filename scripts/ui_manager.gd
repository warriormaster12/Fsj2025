extends CanvasLayer

@onready var color_rect: ColorRect = $FadeInOutRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, 1.0).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
