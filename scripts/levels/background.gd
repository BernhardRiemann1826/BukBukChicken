extends ParallaxBackground

@export var scroll_speed := Vector2(50, 0)  # Speed of automatic scrolling
var score = 0

func _process(delta):
	# Increment scroll_offset over time to scroll background automatically
	scroll_offset += scroll_speed * delta

func update_score(amount: int):
	score += amount
	print("Score:", score)
	# TODO: Update on-screen stamina bar or UI here
