extends Node2D

func _on_play_button_pressed():
	SceneManager.transition_to("res://castle/intro_ui.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
