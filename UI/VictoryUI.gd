extends CanvasLayer

@onready var control = $Control
@onready var panel = $Control/Panel
@onready var label = $Control/Panel/Label
@onready var stats_label = $Control/Panel/StatsLabel

var victory_visible = false

func _ready():
	hide_victory()

func _input(event):
	if victory_visible and event.is_pressed():
		go_to_home_screen()

func show_victory():
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
		"Press any key to return to main menu\n(or wait 10 seconds)"
	
	# Fade in effect
	var tween = create_tween()
	panel.modulate.a = 0.0
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)
	
	# Auto-return to home after 10 seconds as fallback
	get_tree().create_timer(10.0).timeout.connect(go_to_home_screen)

func hide_victory():
	victory_visible = false
	control.visible = false  # Hide the Control node

func go_to_home_screen():
	# Hide the victory screen first
	hide_victory()
	
	# Reset game statistics
	SceneManager.death_count = 0
	SceneManager.game_variables.clear()
	StarManager.reset_stars()
	SceneManager.start_game_timer()  # Reset the timer properly
	
	# Use call_deferred to ensure the transition happens after current frame
	get_tree().call_deferred("change_scene_to_file", "res://main.tscn")
