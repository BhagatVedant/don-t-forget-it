extends CanvasLayer

var transition_rect: ColorRect
var is_transitioning := false

# Checkpoint system
var current_checkpoint: Node2D = null
var checkpoint_spawn_position: Vector2 = Vector2.ZERO

func _ready():
	# Create a black rectangle that covers the whole screen
	transition_rect = ColorRect.new()
	transition_rect.color = Color(0, 0, 0, 0) # Start transparent
	transition_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(transition_rect)

func transition_to(scene_path: String, color: Color = Color.BLACK):
	if is_transitioning:
		return

	is_transitioning = true
	
	# Fade to black
	await fade_in(color)
	
	# Change the scene
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		print("Error changing scene: ", error)
		is_transitioning = false
		return

	# Fade from black
	await fade_out()
	
	is_transitioning = false

func fade_in(color: Color = Color.BLACK):
	transition_rect.color = color
	var tween = create_tween()
	tween.tween_property(transition_rect, "color:a", 1.0, 0.5)
	await tween.finished

func fade_out():
	var tween = create_tween()
	tween.tween_property(transition_rect, "color:a", 0.0, 0.5)
	await tween.finished

# Checkpoint management functions
func set_current_checkpoint(checkpoint: Node2D):
	current_checkpoint = checkpoint
	if checkpoint:
		checkpoint_spawn_position = checkpoint.global_position
		print("Current checkpoint set to: ", checkpoint_spawn_position)

func get_checkpoint_spawn_position() -> Vector2:
	return checkpoint_spawn_position

func has_checkpoint() -> bool:
	return current_checkpoint != null

func respawn_player(player: Node2D):
	if has_checkpoint():
		player.global_position = checkpoint_spawn_position
		print("Player respawned at checkpoint: ", checkpoint_spawn_position)
	else:
		print("No checkpoint available for respawn")
