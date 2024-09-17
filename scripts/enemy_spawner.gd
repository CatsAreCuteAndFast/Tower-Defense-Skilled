extends Node2D

@onready var wave_progress: ProgressBar = $CanvasLayer/Control/WaveProgress
@onready var wave_text: Label = $CanvasLayer/Control/WaveText

@export var wave_length = 10.0
@export var break_between_waves = 10.0
@export var first_wave_enemies = 5
@export var enemies_per_wave = 1
@export var enemy_scene : PackedScene

var elapsed_time : float

var current_state = "idle"
var wave = 0
var enemies_to_spawn : int
var when_to_spawn : Array[float]

func _ready() -> void:
	create_random_increments(wave_length, enemies_to_spawn)
	
func _process(delta: float) -> void:
	elapsed_time += delta
	
	if current_state == "idle" and elapsed_time > break_between_waves:
		current_state = "attack"
		elapsed_time = 0.0
		
		enemies_to_spawn = first_wave_enemies + wave * enemies_per_wave
		create_random_increments(wave_length, enemies_to_spawn)
		
		wave += 1
		wave_text.text = "Wave " + str(wave)
		wave_progress.self_modulate = Color("ff0000")
	elif current_state == "attack" and elapsed_time > wave_length and len(get_tree().get_nodes_in_group("enemies")) == 0:
		current_state = "idle"
		elapsed_time = 0.0
		delete_players()
		
		wave_progress.self_modulate = Color("58ff1d")
	
	if current_state == "attack":
		wave_progress.value = 1 - min(1, elapsed_time / wave_length)
		check_for_enemy_spawn()
	elif current_state == "idle":
		wave_progress.value = 1 - min(1, elapsed_time / break_between_waves)
		
	
func create_random_increments(time : float, amount : int):
	when_to_spawn.clear()
	for i in range(amount):
		when_to_spawn.append(randf_range(0, time))

func check_for_enemy_spawn():
	for spawn_time in when_to_spawn:
		if elapsed_time > spawn_time:
			when_to_spawn.erase(spawn_time)
			spawn_enemy()
			
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	
func delete_players():
	for player in get_tree().get_nodes_in_group("players"):
		player.destroy(false)
