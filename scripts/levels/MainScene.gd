extends Node2D

@onready var chicken = $chicken
@onready var item_container = $ItemContainer
@onready var chicken_sound = $chicken/ChickenSound
@onready var chicken_timer = $chicken/ChickenTimer

# Preload item scenes
var item_scenes = [
	preload("res://scenes/worm1.tscn"),
	preload("res://scenes/worm2.tscn"),
	preload("res://scenes/mushroom.tscn"),
]

var item_speed = 100.0
var spawn_interval = 1.0
var spawn_timer = 0.0

# Adjust for where you want the items to spawn (tweak as needed)
var spawn_y_min = 730.0
var spawn_y_max = 750.0

# Play chicken sound on and off
var chicken_sound_timer_interval = randf_range(10, 30)

func _ready():
	print("MainScene ready")
	randomize()
	chicken.play("pace")
	play_chicken_sound()

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_timer = spawn_interval
		spawn_random_item()

	# Move items
	for item in item_container.get_children():
		if item is Node2D:
			item.position.x -= item_speed * delta
			if item.position.x < -100:
				item.queue_free()

func play_chicken_sound():
	var random_volume = randf_range(-10.0, 0.0)  # Between -6dB and full volume
	chicken_sound.volume_db = random_volume
	chicken_sound.play()
	chicken_timer.start(chicken_sound_timer_interval)   # Replay after 1 second

func _on_ChickenTimer_timeout():
	chicken_sound.stop()
	chicken_sound.play()
	chicken_timer.start(chicken_sound_timer_interval)   # Loop again

func spawn_random_item():
	var scene = item_scenes[randi() % item_scenes.size()]
	var new_item = scene.instantiate() as Node2D

	var screen_width = get_viewport().size.x
	new_item.position.x = screen_width
	new_item.position.y = randf_range(spawn_y_min, spawn_y_max)

	item_container.add_child(new_item)
