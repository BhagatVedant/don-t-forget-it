extends CanvasLayer

@onready var control = $Control
@onready var panel = $Control/Panel
@onready var label = $Control/Panel/Label
@onready var stats_label = $Control/Panel/StatsLabel

var victory_visible = false

func _ready():
	hide_victory()

func _input(event):
	if victory_visible:
		if event is InputEventKey and event.pressed:
			print("Key pressed: ", event.keycode)  # Debug print
			if event.keycode == KEY_SPACE:
				print("SPACE key detected!")  # Debug print
				go_to_home_screen()
		elif event.is_action_pressed("ui_accept"):
			print("ui_accept detected!")  # Debug print
			go_to_home_screen()

func show_victory():
	print("Showing victory screen...")  # Debug print
	victory_visible = true
	control.visible = true  # Show the Control node
	
	# Get game stats
	var stars_collected = StarManager.get_star_count()
	var total_stars = StarManager.get_total_stars()
	var deaths = SceneManager.get_death_count()
	var play_time = int(SceneManager.get_play_time())
	var minutes = int(play_time / 60.0)
	var seconds = play_time % 60
	
	# Set main victory message in center top
	label.text = "You Win!"
	
	# Set stats below the main message
	stats_label.text = "Stars Taken: %d/%d\n" % [stars_collected, total_stars] + \
		"Times Reset: %d\n" % deaths + \
		"Total Time to Clear: %d:%02d\n\n" % [minutes, seconds] + \
		"Press SPACE to go to home screen"
	
	# Fade in effect
	var tween = create_tween()
	panel.modulate.a = 0.0
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)

func hide_victory():
	victory_visible = false
	control.visible = false  # Hide the Control node

func go_to_home_screen():
	print("Going to home screen...")  # Debug print
	# Reset game statistics
	SceneManager.death_count = 0
	SceneManager.game_variables.clear()
	StarManager.reset_stars()
	SceneManager.start_game_timer()  # Reset the timer properly
	
	SceneManager.transition_to("res://main.tscn")
