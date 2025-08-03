extends CanvasLayer

var transition_rect: ColorRect
var is_transitioning := false
var timer_ui: Control = null
var game_over_ui: Control = null
var victory_ui: CanvasLayer = null

# Checkpoint system
var current_checkpoint: Node2D = null
var checkpoint_spawn_position: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO  # Starting position of the level

# Game state variables
var game_variables: Dictionary = {}
var death_count: int = 0
var start_time: float = 0.0

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
	
	# Load and add victory UI
	var victory_scene = preload("res://VictoryUI.tscn")
	victory_ui = victory_scene.instantiate()
	add_child(victory_ui)
	
	# Initialize game tracking
	start_time = Time.get_time_dict_from_system()["hour"] * 3600 + Time.get_time_dict_from_system()["minute"] * 60 + Time.get_time_dict_from_system()["second"]

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

# Victory UI functions
func show_victory():
	if victory_ui:
		victory_ui.show_victory()

# Variable management functions
func set_variable(var_name: String, value):
	game_variables[var_name] = value

func get_variable(var_name: String, default_value = null):
	return game_variables.get(var_name, default_value)

func has_variable(var_name: String) -> bool:
	return var_name in game_variables

# Death tracking
func increment_death_count():
	death_count += 1

func get_death_count() -> int:
	return death_count

# Time tracking
func start_game_timer():
	start_time = Time.get_time_dict_from_system()["hour"] * 3600 + Time.get_time_dict_from_system()["minute"] * 60 + Time.get_time_dict_from_system()["second"]

func get_play_time() -> float:
	var current_time = Time.get_time_dict_from_system()["hour"] * 3600 + Time.get_time_dict_from_system()["minute"] * 60 + Time.get_time_dict_from_system()["second"]
	return current_time - start_time
