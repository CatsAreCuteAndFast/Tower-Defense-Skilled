extends CharacterBody2D

@export var speed = 150.0
@export var accel = 50.0

@onready var point_light: PointLight2D = $PointLight2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

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

func _on_area_2d_mouse_entered() -> void:
	print("hi")

func _on_area_2d_mouse_exited() -> void:
	print("hi")
