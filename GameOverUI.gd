extends Control

@onready var main_text = $MainText
@onready var bottom_text = $BottomText
@onready var continue_text = $ContinueText
@onready var background = $Background

var waiting_for_input = false

func _ready():
	# Hide initially
	visible = false

func _input(event):
	if waiting_for_input and event.pressed:
		waiting_for_input = false
		fade_to_main_screen()

func show_game_over():
	visible = true
	
	# Fade in the black screen
	var tween = create_tween()
	background.modulate.a = 0.0
	main_text.modulate.a = 0.0
	bottom_text.modulate.a = 0.0
	continue_text.modulate.a = 0.0
	
	# Fade in background first
	tween.tween_property(background, "modulate:a", 1.0, 1.0)
	
	# Then fade in main text
	tween.tween_property(main_text, "modulate:a", 1.0, 1.5)
	
	# Then fade in bottom text
	tween.tween_property(bottom_text, "modulate:a", 1.0, 1.0)
	
	# Wait for tween to finish, then show continue text and wait for input
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	
	# Show continue text
	var continue_tween = create_tween()
	continue_tween.tween_property(continue_text, "modulate:a", 1.0, 0.5)
	await continue_tween.finished
	
	# Now wait for player input
	waiting_for_input = true

func fade_to_main_screen():
	# Fade out everything
	var fade_tween = create_tween()
	fade_tween.parallel().tween_property(background, "modulate:a", 0.0, 0.5)
	fade_tween.parallel().tween_property(main_text, "modulate:a", 0.0, 0.5)
	fade_tween.parallel().tween_property(bottom_text, "modulate:a", 0.0, 0.5)
	fade_tween.parallel().tween_property(continue_text, "modulate:a", 0.0, 0.5)
	
	await fade_tween.finished
	go_to_main_screen()

func go_to_main_screen():
	# Transition to main screen
	SceneManager.transition_to("res://main.tscn")
