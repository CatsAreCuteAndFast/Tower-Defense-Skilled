extends Polygon2D

@export var health = 3
@export var health_colors : Array[Color]

var players: Array[Node]
var current_color : Color
var color_tween : Tween

func _ready():
	current_color = health_colors[health - 1]
	color = current_color
	players = get_tree().get_nodes_in_group("players")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left click"):
		players = get_tree().get_nodes_in_group("players")
		var click_position = get_global_mouse_position()
		var clicked_player : CharacterBody2D
		
		for player in players:
			if get_global_mouse_position().distance_to(player.global_position) < 40:
				clicked_player = player
				break
			
		if clicked_player:
			GameEvents.emit_signal("player_switch_requested", clicked_player)
			
func damage():
	health -= 1
	if health == 0:
		get_tree().reload_current_scene()
	current_color = health_colors[health - 1]
	
	if color_tween:
		color_tween.kill()
	color_tween = create_tween()
	color_tween.tween_property(self, "color", current_color, 1.0)
