extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label
var fade_tween: Tween

func _ready():
	hide()

func show_step(text: String):
	# Stop any existing fade
	if fade_tween:
		fade_tween.kill()
	
	# Show and reset panel opacity
	visible = true
	if panel:
		panel.modulate = Color(1, 1, 1, 1)
		panel.show()
	
	if label:
		label.text = text

func hide_tutorial():
	if panel:
		panel.hide()
	hide()

func fade_out():
	if not panel:
		return
		
	if fade_tween:
		fade_tween.kill()
	
	fade_tween = create_tween()
	fade_tween.tween_property(panel, "modulate", Color(1, 1, 1, 0), 1.0)
	await fade_tween.finished
	hide()
