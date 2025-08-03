extends Node2D

@onready var area_2d = $spike

func _ready():
	# Check if area_2d exists before connecting
	if area_2d:
		area_2d.body_entered.connect(_on_area_2d_body_entered)
		print("Spike ready, collision connected at position: ", global_position)
	else:
		print("Error: spike Area2D node not found!")

func _on_area_2d_body_entered(body):
	print("Spike collision detected with: ", body.name, " at position: ", body.global_position)
	if body.name == "Player":
		print("Player hit spike - resetting to checkpoint")
		
		# First try using current checkpoint system
		if SceneManager.current_checkpoint:
			SceneManager.current_checkpoint.reset_player_to_checkpoint()
			print("Reset using current checkpoint system")
		else:
			# Fallback to player's die method
			body.die()
			print("Reset using player die method")
