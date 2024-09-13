extends Polygon2D

var players: Array[Node]

func _ready():
	players = get_tree().get_nodes_in_group("players")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left click"):
		var click_position = get_global_mouse_position()
		var clicked_player : CharacterBody2D
		
		for player in players:
			if player.mouse_hovered:
				clicked_player = player
				break
			
		if clicked_player:
			GameEvents.emit_signal("player_switch_requested", clicked_player)
