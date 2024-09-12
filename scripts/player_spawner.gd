extends Polygon2D

var players: Array[Node]

func _ready():
	players = get_tree().get_nodes_in_group("players")

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var click_position = get_global_mouse_position()
		var clicked_player = get_player_at_position(click_position)
		
		if clicked_player:
			GameEvents.emit_signal(clicked_player)
			print("hi")

func get_player_at_position(position: Vector2) -> CharacterBody2D:
	for player in players:
		if player.get_node("Area2D").has_point(player.to_local(position)):
			return player
	return null
