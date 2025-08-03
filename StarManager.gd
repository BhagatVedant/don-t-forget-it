extends Node

var star_count: int = 0

# Signal for when star count changes
signal star_count_changed(new_count: int)

func _ready():
	# Connect to the signal for UI updates
	star_count_changed.connect(_on_star_count_changed)

func add_star():
	star_count += 1
	star_count_changed.emit(star_count)
	print("Star collected! Total: ", star_count)

func get_star_count() -> int:
	return star_count

func reset_stars():
	star_count = 0
	star_count_changed.emit(star_count)

func _on_star_count_changed(_new_count: int):
	# This can be used for achievements, unlocks, etc.
	pass
