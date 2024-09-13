extends State
class_name NotFocused

@onready var player_light: PointLight2D = $"../../PointLight2D"
@onready var player_outline: Polygon2D = $"../../Shape/Node2D/Polygon2D2"

var animation_progress = 0.0
var animation_tween : Tween

var original_texture_scale : float
var original_modulate_alpha : float

func Enter():
	animation_progress = 0.0
	original_texture_scale = player_light.texture_scale
	original_modulate_alpha = player_outline.self_modulate.a
	animation_tween = create_tween()
	animation_tween.tween_property(self, "animation_progress", 1.0, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func Update(delta):
	player_light.texture_scale = lerpf(original_texture_scale, 1, animation_progress)
	player_outline.self_modulate.a = lerpf(original_modulate_alpha, 0, animation_progress)

func Exit():
	animation_tween.kill()
