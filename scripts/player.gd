extends CharacterBody2D

@export var speed = 150.0
@export var accel = 50.0

@onready var point_light: PointLight2D = $PointLight2D
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_explosion: GPUParticles2D = $Shape/Polygon2D/PlayerExplosion
@onready var polygon_2d_2: Polygon2D = $Shape/Node2D/Polygon2D2
@onready var polygon_2d: Polygon2D = $Shape/Polygon2D

var focused = true
var mouse_hovered = false

var destroy_tween : Tween

func _ready() -> void:
	GameEvents.player_switch_requested.connect(_on_player_switch)
	GameEvents.emit_signal("player_switch_requested", self)
	point_light.color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))

func _physics_process(_delta: float) -> void:
	var direction : Vector2
	if focused:
		direction = Input.get_vector("left", "right", "up", "down")
		direction = direction.normalized()
	else:
		direction = Vector2(0, 0)
		
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	
	move_and_slide()

func _on_area_2d_mouse_entered() -> void:
	mouse_hovered = true

func _on_area_2d_mouse_exited() -> void:
	mouse_hovered = false
	
func _on_player_switch(new_player : CharacterBody2D):
	if new_player == self:
		if not focused:
			focused = true
			state_machine.change_state("Focused")
	elif focused:
		focused = false
		state_machine.change_state("NotFocused")
		
func destroy(violent : bool):
	if violent:
		point_light.color = Color(0, 0, 0, 0)
		polygon_2d.self_modulate = Color(0, 0, 0, 0)
		polygon_2d_2.modulate = Color(0, 0, 0, 0)
		player_explosion.emitting = true
		await player_explosion.finished
		queue_free()
	elif not violent:
		destroy_tween = create_tween().set_parallel(true)
		destroy_tween.tween_property(point_light, "color", Color(0, 0, 0, 0), 1.0)
		destroy_tween.tween_property(polygon_2d, "self_modulate", Color(0, 0, 0, 0), 1.0)
		destroy_tween.tween_property(polygon_2d_2, "modulate", Color(0, 0, 0, 0), 1.0)
		await destroy_tween.finished
		queue_free()
		
