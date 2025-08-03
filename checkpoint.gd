extends Node2D

@onready var area_2d = $Area2D
@onready var sprite_2d = $Sprite2D

@export var checkpoint_level: int = 1  # Which checkpoint level this is (1, 2, etc.)
@export var timer_duration: float = 5.0  # Time limit for each level

var is_activated = false
var spawn_position: Vector2
var current_timer: float = 0.0
var is_timing: bool = false
var player_in_level: CharacterBody2D = null
var just_entered: bool = false

# Ability progression system
var ability_stages = [
	{"can_move": true, "can_jump": true, "can_dash": true, "can_double_jump": false},  # Stage 0: Basic abilities
	{"can_move": true, "can_jump": true, "can_dash": false, "can_double_jump": false}, # Stage 1: Lost dash
	{"can_move": true, "can_jump": false, "can_dash": false, "can_double_jump": false}, # Stage 2: Lost jump
	{"can_move": false, "can_jump": false, "can_dash": false, "can_double_jump": false}, # Stage 3: Lost all movement
]

var current_ability_stage: int = 0

func _ready():
	# Set spawn position to this checkpoint's position
	spawn_position = global_position
	
	# Connect the area signal
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	area_2d.body_exited.connect(_on_area_2d_body_exited)
	
	# Start with frame 0 (inactive checkpoint)
	sprite_2d.frame = 0

func _process(delta):
	# Handle timer countdown when player is in level
	if is_timing and player_in_level:
		current_timer -= delta
		SceneManager.update_timer(current_timer)  # Update global timer
		if current_timer <= 0:
			time_up()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_level = body
		just_entered = true
		
		# Reset the flag after a short delay
		get_tree().create_timer(0.2).timeout.connect(func(): just_entered = false)
		
		if not is_activated:
			# This is a new checkpoint - activate it
			activate_checkpoint()
		else:
			# Player returned to already activated checkpoint, stop timing only if timer was running
			if is_timing:
				stop_timing()

func _on_area_2d_body_exited(body):
	if body.name == "Player" and is_activated:
		player_in_level = body
		
		# Add small delay to prevent immediate timer restart on quick re-entry
		await get_tree().create_timer(0.1).timeout
		
		# Only start timer if player is still outside and hasn't just re-entered
		if not just_entered and not is_timing:
			start_level_timer()
		
		just_entered = false

func activate_checkpoint():
	# First, stop any active timers from other checkpoints
	if SceneManager.current_checkpoint and SceneManager.current_checkpoint != self:
		SceneManager.current_checkpoint.force_stop_timing()
	
	is_activated = true
	
	# Change to frame 1 (activated checkpoint)
	sprite_2d.frame = 1
	
	# Play checkpoint sound
	var audio_manager = get_node("/root/AudioManager")
	if audio_manager:
		audio_manager.play_checkpoint_sound()
	
	# Reset abilities to full when reaching new checkpoint
	current_ability_stage = 0
	if player_in_level:
		restore_all_abilities()
	
	# Set this as the current spawn point
	set_as_current_spawn_point()
	
	# Special handling for checkpoint 2 - grant double jump
	if checkpoint_level == 2:
		grant_double_jump()
	
	print("Checkpoint ", checkpoint_level, " activated at position: ", global_position)

func start_level_timer():
	current_timer = timer_duration
	is_timing = true
	SceneManager.show_timer(current_timer)  # Show global timer
	print("Level timer started: ", timer_duration, " seconds")

func stop_timing():
	is_timing = false
	current_timer = 0.0
	SceneManager.hide_timer()  # Hide global timer
	print("Timer stopped - player returned to checkpoint")

func force_stop_timing():
	# Force stop timing from another checkpoint
	is_timing = false
	current_timer = 0.0
	print("Timer force stopped on checkpoint ", checkpoint_level)

func time_up():
	print("Time up! Player loses an ability")
	is_timing = false
	SceneManager.hide_timer()  # Hide global timer
	
	# Lose an ability
	lose_ability()
	
	# Reset player to checkpoint
	if player_in_level:
		reset_player_to_checkpoint()

func lose_ability():
	current_ability_stage += 1
	
	if current_ability_stage >= ability_stages.size():
		# Player lost all abilities - send back to start
		send_to_start()
		return
	
	# Apply new ability restrictions
	if player_in_level:
		apply_abilities_to_player()

func apply_abilities_to_player():
	var abilities = ability_stages[current_ability_stage]
	
	# Apply abilities to player
	player_in_level.can_dash = abilities.can_dash
	player_in_level.can_double_jump = abilities.can_double_jump
	
	# Handle movement and jump restrictions
	if not abilities.can_move:
		player_in_level.disable_all_movement()
	else:
		player_in_level.enable_movement()
	
	if not abilities.can_jump:
		player_in_level.disable_jump()
	else:
		player_in_level.enable_jump()
	
	print("Applied abilities - Stage ", current_ability_stage)
	
	# Check if player lost all movement (stage 3) - show game over
	if current_ability_stage == 3:  # Stage 3 is no movement
		print("Player lost all movement - showing game over screen")
		# Small delay to let the restriction apply
		await get_tree().create_timer(0.5).timeout
		send_to_start()

func restore_all_abilities():
	if not player_in_level:
		return
	
	# Give back all basic abilities
	player_in_level.can_dash = true
	player_in_level.can_double_jump = false  # Will be granted specifically at checkpoint 2
	
	# Special handling: if this is checkpoint 2 or later, grant double jump
	if checkpoint_level >= 2:
		player_in_level.can_double_jump = true
	
	# Enable all movement
	player_in_level.enable_movement()
	player_in_level.enable_jump()
	
	print("All abilities restored!")

func reset_player_to_checkpoint():
	if player_in_level:
		player_in_level.global_position = spawn_position
		player_in_level.velocity = Vector2.ZERO
		
		# Stop any active timer
		is_timing = false
		SceneManager.hide_timer()
		
		# Don't lose abilities on spike death - keep current ability stage
		apply_abilities_to_player()
		
		print("Player reset to checkpoint ", checkpoint_level)

func send_to_start():
	print("Player sent back to start - lost all abilities")
	current_ability_stage = 0  # Reset abilities
	
	# Hide the timer
	SceneManager.hide_timer()
	
	# Show game over screen instead of immediate reset
	SceneManager.show_game_over()

func grant_double_jump():
	if player_in_level:
		player_in_level.can_double_jump = true
		show_dialogue("Double jump obtained! Press SPACE again in mid-air!")

func show_dialogue(text: String):
	# Find DialogueBox in the scene
	var dialogue_box = get_tree().get_first_node_in_group("dialogue")
	if not dialogue_box:
		# Try to find it in the scene
		dialogue_box = get_node_or_null("/root/*/DialogueBox")
	
	if dialogue_box:
		dialogue_box.start_dialogue(text)
	else:
		print("Dialogue: ", text)

func set_as_current_spawn_point():
	# Use the global SceneManager to set this checkpoint
	SceneManager.set_current_checkpoint(self)

func get_spawn_position() -> Vector2:
	return spawn_position
