extends Node2D

@onready var sprite: Polygon2D = $Polygon2D
@onready var green_explosion: GPUParticles2D = $Polygon2D/GreenExplosion
@onready var red_explosion: GPUParticles2D = $Polygon2D/RedExplosion
@onready var state_machine: StateMachine = $StateMachine
@onready var hit: AudioStreamPlayer2D = $Hit
@onready var green_explosion_2: GPUParticles2D = $Polygon2D/GreenExplosion2
@onready var red_explosion_2: GPUParticles2D = $Polygon2D/RedExplosion2

@export var transform_radius = 450.0
@export var move_speed = 50.0
@export var transform_time = 1.0

var transformed = false
var transform_tween : Tween
var transform_color : String
var transform_particle : GPUParticles2D
var transform_modulate : Color

var destroy_particle : GPUParticles2D
var destroy_tween : Tween
var destroyed = false

var moving = true

var camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	
	transform_particle = red_explosion
	destroy_particle = red_explosion_2
	transform_modulate = Color(10, 0, 0, 1)
	
	var rotation_value = randi_range(-30, 30)
	rotation_value = rotation_value + 180 if randi() % 2 == 0 else rotation_value
	rotation = deg_to_rad(rotation_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving:
		sprite.position.y -= move_speed * delta
	
	if sprite.position.y < transform_radius:
		random_transform()
		
func random_transform():
	if transformed:
		return

	transformed = true
	
	transform_color = "red" if randi() % 2 == 0 else "blue"
	if transform_color == "red":
		destroy_particle = red_explosion_2
		transform_particle = red_explosion
		transform_modulate = Color(10, 0, 0, 1)
		state_machine.change_state("RedEnemy")
	else:
		destroy_particle = green_explosion_2
		transform_particle = green_explosion
		transform_modulate = Color(0, 10, 0, 1)
		state_machine.change_state("GreenEnemy")
	
	transform_tween = create_tween()
	transform_tween.tween_property(sprite, "self_modulate", transform_modulate, transform_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(transform_time / 2).timeout
	transform_particle.emitting = true
	
func destroy(violent : bool):
	if destroyed:
		return
		
	destroyed = true
	moving = false
		
	if not violent:
		destroy_tween = create_tween()
		destroy_tween.tween_property(sprite, "self_modulate", Color(0, 0, 0, 0), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await destroy_tween.finished
		queue_free()
	elif violent:
		hit.play()
		sprite.self_modulate = Color(0, 0, 0, 0)
		destroy_particle.emitting = true
		destroy_particle.speed_scale = 2
		
		var spawner = get_tree().get_first_node_in_group("spawner")
		spawner.damage()
		
		camera.Screenshake(10, 5)
		
		await destroy_particle.finished
		queue_free()
