extends Control

@onready var timer_label = $TimerLabel

var current_timer: float = 0.0
var timer_active: bool = false

func _ready():
	# Position at top right
	set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	hide_timer()

func show_timer(time: float):
	current_timer = time
	timer_active = true
	visible = true
	update_display()

func hide_timer():
	timer_active = false
	visible = false

func update_timer(time: float):
	if timer_active:
		current_timer = time
		update_display()

func update_display():
	if timer_label:
		timer_label.text = "%.1f" % max(0, current_timer)
		
		# Change color based on time remaining
		if current_timer <= 2.0:
			timer_label.modulate = Color.RED
		elif current_timer <= 3.0:
			timer_label.modulate = Color.ORANGE
		else:
			timer_label.modulate = Color.WHITE
