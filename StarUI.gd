extends CanvasLayer

@onready var star_icon = $Panel/HBoxContainer/StarIcon
@onready var star_count_label = $Panel/HBoxContainer/StarCountLabel

func _ready():
	# Connect to StarManager signal
	StarManager.star_count_changed.connect(_on_star_count_changed)
	
	# Initialize display
	update_star_display(StarManager.get_star_count())

func _on_star_count_changed(new_count: int):
	update_star_display(new_count)

func update_star_display(count: int):
	star_count_label.text = "x%02d" % count
