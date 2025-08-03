extends Node2D

func _ready():
	print("Test scene loaded")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Testing checkpoint instruction...")
		# Create and show the instruction UI for testing
		var instruction_scene = preload("res://CheckpointInstructionUI.tscn")
		var instruction_ui = instruction_scene.instantiate()
		add_child(instruction_ui)
		instruction_ui.show_instruction()
