extends State
class_name RedEnemy

@onready var enemy: Node2D = $"../.."
@onready var sprite: Polygon2D = $"../../Polygon2D"

@export var destroy_radius = 200.0

var running = false

func Enter():
	running = true

func Update(delta):
	if sprite.position.y < destroy_radius:
		enemy.destroy(true)
		
func Exit():
	running = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not running:
		return
		
	var players = get_tree().get_nodes_in_group("players")
	
	if body in players:
		enemy.destroy(false)
		body.destroy(false)
