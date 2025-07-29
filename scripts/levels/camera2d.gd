extends Camera2D

@export var target: Node2D
@export var scroll_speed := 100.0

func _ready():
	if target == null:
		print("⚠️  Camera target not assigned!")

func _process(delta):
	if target:
		# Move the target node horizontally rightward at scroll_speed
		target.global_position.x += scroll_speed * delta
		# Make camera follow the target precisely
		global_position = target.global_position
