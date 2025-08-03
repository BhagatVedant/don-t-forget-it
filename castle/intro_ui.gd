extends CanvasLayer

var showing = true

func _ready():
	$Label.text = "Don't Forget\nOr else"
	$Label3.text = "Make sure they dont put you back" 
	$Label2.text = "Press any key to begin"
	$Label2.modulate.a = 0.0  # hidden at first
	$Label3.modulate.a = 0.0  # hidden at first
	
	var tween = create_tween()
	tween.tween_property($Label3, "modulate:a", 1.0, 1.0).set_delay(1.0)
	tween.tween_property($Label2, "modulate:a", 1.0, 1.0).set_delay(2.0)
	tween.play()

func _input(event):
	if showing and event.is_pressed():
		showing = false
		start_game()

func start_game():
	var tween = create_tween().set_parallel()
	tween.tween_property($ColorRect, "modulate:a", 0.0, 0.5)
	tween.tween_property($Label, "modulate:a", 0.0, 0.5)
	tween.tween_property($Label2, "modulate:a", 0.0, 0.5)
	tween.tween_property($Label3, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	# Start the game timer when transitioning to the main game
	SceneManager.start_game_timer()
	SceneManager.transition_to("res://castle/CastleRoom.tscn", Color.WHITE)
