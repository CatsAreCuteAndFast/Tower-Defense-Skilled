extends CharacterBody2D

@export var speed = 150.0
@export var accel = 50.0

@onready var point_light: PointLight2D = $PointLight2D

var focused = true

func _ready() -> void:
	point_light.color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))

func _physics_process(_delta: float) -> void:
	if not focused:
		return
		
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	direction = direction.normalized()
	
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	
	move_and_slide()
