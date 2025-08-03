extends CanvasLayer

func _ready():
	pass

func _on_back_button_pressed():
	SceneManager.transition_to("res://main.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneManager.transition_to("res://main.tscn")
