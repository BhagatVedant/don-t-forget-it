extends CanvasLayer

@onready var control = $Control
@onready var panel = $Control/Panel

var showing = false

func _ready():
	# Add to group so checkpoint can find it
	add_to_group("checkpoint_instruction_ui")
	hide_instruction()

func _input(event):
	if showing and event.is_pressed():
		hide_instruction()
		# Resume the game
		get_tree().paused = false

func show_instruction():
	showing = true
	control.visible = true
	
	# Pause the game while showing instructions
	get_tree().paused = true
	
	# Fade in effect (process_mode set to PROCESS_MODE_ALWAYS so it works when paused)
	process_mode = Node.PROCESS_MODE_ALWAYS
	var tween = create_tween()
	panel.modulate.a = 0.0
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)

func hide_instruction():
	showing = false
	control.visible = false
	process_mode = Node.PROCESS_MODE_INHERIT
