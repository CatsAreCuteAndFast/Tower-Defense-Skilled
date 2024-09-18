extends State
class_name OnPlayerSpawnReady

var hovered = false
var player_scene = preload("res://scenes/player.tscn")

func Update(delta):
	if Input.is_action_just_pressed("left click") and get_global_mouse_position().distance_to(global_position) < 40:
		var new_player = player_scene.instantiate()
		new_player.global_position = self.global_position
		get_tree().current_scene.add_child(new_player)
		Transitioned.emit(self, "OnPlayerSpawnNotReady")
