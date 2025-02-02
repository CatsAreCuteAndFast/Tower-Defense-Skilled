extends State
class_name Focused

@onready var player_light: PointLight2D = $"../../PointLight2D"
@onready var player_outline: Polygon2D = $"../../Shape/Node2D/Polygon2D2"

var animation_progress = 0.0
var animation_tween : Tween
var bobbing_tween : Tween

var original_texture_scale : float
var original_modulate_alpha : float

func Enter():
	animation_progress = 0.0
	original_texture_scale = player_light.texture_scale
	original_modulate_alpha = player_outline.self_modulate.a
	animation_tween = create_tween()
	animation_tween.tween_property(self, "animation_progress", 1.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await animation_tween.finished
	start_bobbing()

func Update(delta):
	player_light.texture_scale = lerpf(original_texture_scale, 1.5, animation_progress)
	player_outline.self_modulate.a = lerpf(original_modulate_alpha, 1, animation_progress)

func Exit():
	if animation_tween:
		animation_tween.kill()
	if bobbing_tween:
		bobbing_tween.kill()
	
func start_bobbing():
	bobbing_tween = create_tween()
	bobbing_tween.set_loops()
	bobbing_tween.tween_property(self, "animation_progress", 1.0, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	bobbing_tween.tween_property(self, "animation_progress", 0.6, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
