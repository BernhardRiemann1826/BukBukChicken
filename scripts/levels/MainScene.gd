extends Node2D

@onready var camera := $Camera2D
@onready var chicken = $CameraTarget/chicken
@onready var chicken_sound = chicken.get_node("ChickenSound")
@onready var chicken_timer = chicken.get_node("ChickenTimer")
@onready var item_container = $ItemContainer
@onready var game_over_sound = $GameOverSound

var item_scenes = [
	preload("res://scenes/worm1.tscn"),
	preload("res://scenes/worm2.tscn"),
	preload("res://scenes/mushroom.tscn"),
]

var item_speed = 100.0
var spawn_interval = 1.0
var spawn_timer = 0.0

var spawn_y_min = 320.0
var spawn_y_max = 330.0

var chicken_sound_timer_interval = 0
var game_over = false  # Add game_over to prevent unnecessary logic

func _ready():
	print("MainScene ready")
	randomize()
	chicken.play("pace")
	play_chicken_sound()

func _process(delta):
	if game_over:
		return

	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_timer = spawn_interval
		spawn_random_item()

	for item in item_container.get_children():
		if item is Node2D:
			item.position.x -= item_speed * delta
			if item.position.x < -100:
				item.queue_free()

func play_chicken_sound():
	if game_over:
		return
	chicken_sound_timer_interval = randf_range(15, 20)
	chicken_sound.volume_db = randf_range(-10.0, 0.0)
	chicken_sound.play()
	chicken_timer.start(chicken_sound_timer_interval)

func stop_chicken_sound():
	chicken_timer.stop()
	chicken_sound.stop()
	print("Chicken sound and timer stopped")

func _on_ChickenTimer_timeout():
	if game_over:
		return
	chicken_sound.stop()
	chicken_sound.play()
	chicken_sound_timer_interval = randf_range(15, 20)
	chicken_timer.start(chicken_sound_timer_interval)

func spawn_random_item():
	var scene = item_scenes[randi() % item_scenes.size()]
	var new_item = scene.instantiate() as Node2D

	# Spawn ahead of the camera
	var screen_width = get_viewport().size.x
	var camera_x = camera.global_position.x
	new_item.global_position = Vector2(camera_x + screen_width / 2, randf_range(spawn_y_min, spawn_y_max))
	new_item.z_index = 3

	item_container.add_child(new_item)
	
func play_game_over_sound():
	game_over_sound.play()
