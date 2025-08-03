extends CanvasLayer

@onready var label = $Panel/Label
@onready var indicator = $Panel/Indicator
@onready var timer = $Timer
@onready var panel = $Panel
@onready var blink_tween: Tween

var full_text = ""
var current_char = 0
var is_typing = false

signal dialogue_finished

func _ready():
	label.text = ""
	indicator.hide()
	timer.timeout.connect(_on_Timer_timeout)

func start_dialogue(text: String):
	full_text = text
	current_char = 0
	label.text = ""
	is_typing = true
	indicator.hide()
	if blink_tween:
		blink_tween.kill()
	timer.start()
	panel.show()  # Make sure panel is visible
	show()        # Make sure canvas layer is visible
	
	# Disable player input during dialogue
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		player = get_tree().current_scene.find_child("Player", true, false)
	if player and player.has_method("disable_input"):
		player.disable_input()

func _input(event):
	if visible:
		if (event is InputEventMouseButton and event.pressed) or event.is_action_pressed("ui_accept"):
			on_ui_accept()
			get_viewport().set_input_as_handled()

func on_ui_accept():
	if visible:
		if is_typing:
			# Skip the typewriter effect
			timer.stop()
			label.text = full_text
			is_typing = false
			indicator.show()
			_start_blinking_indicator()
		else:
			# Advance dialogue or hide
			if blink_tween:
				blink_tween.kill()
			panel.hide()  # Hide panel
			hide()        # Hide canvas layer
			
			# Re-enable player input after dialogue
			var player = get_tree().get_first_node_in_group("player")
			if not player:
				player = get_tree().current_scene.find_child("Player", true, false)
			if player and player.has_method("enable_input"):
				player.enable_input()
			
			emit_signal("dialogue_finished")

func _on_Timer_timeout():
	if current_char < full_text.length():
		label.text += full_text[current_char]
		current_char += 1
	else:
		is_typing = false
		# Show indicator much faster after text finishes
		await get_tree().create_timer(0.1).timeout
		indicator.show()
		_start_blinking_indicator()
		timer.stop()

func _start_blinking_indicator():
	if blink_tween:
		blink_tween.kill()
	blink_tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	blink_tween.tween_property(indicator, "modulate:a", 0.0, 0.3)  # Faster blinking
	blink_tween.tween_property(indicator, "modulate:a", 1.0, 0.3)
