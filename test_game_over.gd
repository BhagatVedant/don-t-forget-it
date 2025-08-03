extends Node2D

func _ready():
	# Wait 2 seconds then show game over for testing
	await get_tree().create_timer(2.0).timeout
	SceneManager.show_game_over()
