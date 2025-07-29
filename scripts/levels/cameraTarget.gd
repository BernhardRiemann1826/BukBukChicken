extends Node2D

@onready var chicken_sprite: AnimatedSprite2D = $chicken
@onready var peck_area: Area2D = $chicken/PeckArea
@onready var stamina_bar: ProgressBar = $"../CanvasLayer/StaminaBar"
@onready var chicken_sound: AudioStreamPlayer2D = $chicken/ChickenSound
@onready var peck_worm_sound: AudioStreamPlayer2D = $chicken/PeckWormSound
@onready var peck_mushroom_sound: AudioStreamPlayer2D = $chicken/PeckMushroomSound

var is_pecking = false
var stamina = 50
var max_stamina = 100
var game_over = false

func _process(delta):
	if game_over:
		return
	if Input.is_action_just_pressed("peck") and not is_pecking:
		is_pecking = true
		chicken_sprite.play("peck")

		# Enable collision for pecking
		peck_area.monitoring = true
		peck_area.set_deferred("monitoring", true)

func _on_chicken_animation_finished():
	if chicken_sprite.animation == "peck":
		is_pecking = false
		peck_area.monitoring = false
		chicken_sprite.play("pace")

func _on_PeckArea_area_entered(area):
	if game_over:
		return

	if area.name.contains("worm"):
		stamina = min(stamina + 10, max_stamina)
		if not peck_worm_sound.playing:
			peck_worm_sound.play()
		area.queue_free()

	elif area.name.contains("mushroom"):
		stamina = max(stamina - 15, 0)
		if not peck_mushroom_sound.playing:
			peck_mushroom_sound.play()
		area.queue_free()

	update_stamina_bar()
	
	var main_scene = get_tree().get_root().get_node("MainScene")
	if stamina <= 0 and not game_over:
		game_over = true
		chicken_sprite.play("collapse")
		main_scene .stop_chicken_sound()
		main_scene .play_game_over_sound()
		print("Game Over")


func update_stamina_bar():
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina

	# Create a new fill style
	var fill_style := StyleBoxFlat.new()
	if stamina > 50:
		fill_style.bg_color = Color("limegreen") 
	elif stamina > 20:
		fill_style.bg_color = Color.ORANGE
	else:
		fill_style.bg_color = Color.RED

	# Override the fill style
	stamina_bar.add_theme_stylebox_override("fill", fill_style)
