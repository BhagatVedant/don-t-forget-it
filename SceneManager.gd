extends CanvasLayer

var transition_rect: ColorRect
var is_transitioning := false
var timer_ui: Control = null
var game_over_ui: Control = null

# Checkpoint system
var current_checkpoint: Node2D = null
var checkpoint_spawn_position: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO  # Starting position of the level

func _ready():
	# Create a black rectangle that covers the whole screen
	transition_rect = ColorRect.new()
	transition_rect.color = Color(0, 0, 0, 0) # Start transparent
	transition_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(transition_rect)
	
	# Load and add timer UI
	var timer_scene = preload("res://TimerUI.tscn")
	timer_ui = timer_scene.instantiate()
	add_child(timer_ui)
	
	# Load and add game over UI
	var game_over_scene = preload("res://GameOverUI.tscn")
	game_over_ui = game_over_scene.instantiate()
	add_child(game_over_ui)

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
	# Stop timing on previous checkpoint if it exists
	if current_checkpoint and current_checkpoint != checkpoint:
		current_checkpoint.force_stop_timing()
	
	current_checkpoint = checkpoint
	if checkpoint:
		checkpoint_spawn_position = checkpoint.global_position
		print("Current checkpoint set to level ", checkpoint.checkpoint_level, " at: ", checkpoint_spawn_position)

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

func set_start_position(position: Vector2):
	start_position = position

func reset_to_start():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		# Try to find player in the scene
		player = get_node_or_null("/root/*/Player")
	
	if player:
		if start_position != Vector2.ZERO:
			player.global_position = start_position
		else:
			player.global_position = Vector2(64, 320)  # Default start position
		
		# Reset all abilities
		player.can_dash = true
		player.can_double_jump = false
		player.movement_disabled = false
		player.jump_disabled = false
		player.velocity = Vector2.ZERO
		
		print("Player reset to start position")
	
	# Clear current checkpoint
	current_checkpoint = null
	checkpoint_spawn_position = Vector2.ZERO

# Timer UI functions
func show_timer(time: float):
	if timer_ui:
		timer_ui.show_timer(time)

func hide_timer():
	if timer_ui:
		timer_ui.hide_timer()

func update_timer(time: float):
	if timer_ui:
		timer_ui.update_timer(time)

# Game Over UI functions
func show_game_over():
	if game_over_ui:
		game_over_ui.show_game_over()
