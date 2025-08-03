extends Node2D

func _ready():
	# Display fullscreen shortcut info
	print("Press F11 to toggle fullscreen mode")

func _on_play_button_pressed():
	SceneManager.transition_to("res://castle/intro_ui.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	SceneManager.transition_to("res://credits.tscn")
