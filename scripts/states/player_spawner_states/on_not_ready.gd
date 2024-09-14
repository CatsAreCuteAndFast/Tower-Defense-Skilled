extends State
class_name OnPlayerSpawnNotReady

@onready var sprite: Polygon2D = $"../.."

@export var cooldown_timer = 2.0

var cooldown_tween : Tween

func Enter():
	sprite.self_modulate = Color(1, 1, 1, 1)
	cooldown_tween = create_tween()
	cooldown_tween.tween_property(sprite, "self_modulate", Color(15, 15, 15, 1), cooldown_timer).set_trans(Tween.TRANS_LINEAR)
	await cooldown_tween.finished
	Transitioned.emit(self, "OnPlayerSpawnReady")
	
func Exit():
	cooldown_tween.kill()
