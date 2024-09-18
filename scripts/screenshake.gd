extends Camera2D

var shake_strength : float
var shake_fade : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset = RandomOffset()
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
func Screenshake(screenshake_strength, screenshake_fade):
	shake_strength = screenshake_strength
	shake_fade = screenshake_fade
	
func RandomOffset() -> Vector2:
	var random_offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	
	return random_offset
