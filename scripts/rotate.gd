extends Node2D

@export var rotation_per_second = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += rotation_per_second * delta
