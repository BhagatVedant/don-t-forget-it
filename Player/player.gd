extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0  # Increased initial jump force
const DASH_SPEED = 900
const GRAVITY_SCALE = 1.5     # Multiplier for stronger gravity
const APEX_THRESHOLD = 50.0   # Speed threshold for apex detection

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

@export var can_double_jump = true
@export var can_dash = true

var jump_count = 0
var is_dashing = false
var can_process_input = true  # New variable to control input processing
var tutorial_step = 0        # Current tutorial step

func _physics_process(delta):
	# Apply variable gravity based on jump state
	if not is_on_floor():
		var gravity_multiplier = GRAVITY_SCALE
		
		# Reduced gravity near apex of jump (when vertical speed is low)
		if velocity.y < 0 and abs(velocity.y) < APEX_THRESHOLD:
			gravity_multiplier = 0.6  # Slower gravity at apex
		elif velocity.y > 0:
			gravity_multiplier = 2.0  # Faster falling
		
		velocity.y += gravity * gravity_multiplier * delta

	# Only process input if allowed (not during dialogue)
	if can_process_input:
		# Handle Jump - only allowed from tutorial step 1 onwards
		if Input.is_action_just_pressed("jump") and tutorial_step >= 1:
			if is_on_floor():
				jump()
			elif can_double_jump and jump_count < 2:
				jump()

		# Handle Dash - only allowed from tutorial step 2 onwards
		if Input.is_action_just_pressed("dash") and can_dash and not is_dashing and tutorial_step >= 2:
			dash()

		# Movement is always allowed during tutorial
		if not is_dashing:
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# During dialogue, stop horizontal movement
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animation()
	move_and_slide()

func disable_input():
	can_process_input = false

func enable_input():
	can_process_input = true
	tutorial_step = 999  # All inputs allowed

func set_tutorial_step(step: int):
	tutorial_step = step
	can_process_input = true

func jump():
	velocity.y = JUMP_VELOCITY
	jump_count += 1

func dash():
	is_dashing = true
	velocity.x = (-1 if animated_sprite.flip_h else 1) * DASH_SPEED
	animated_sprite.play("roll")  # Play roll animation during dash
	await get_tree().create_timer(0.2).timeout
	is_dashing = false

func _on_floor_changed():
	if is_on_floor():
		jump_count = 0

func update_animation():
	# Don't change animation while dashing/rolling
	if is_dashing:
		return
		
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	
	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x < 0

func reset_abilities():
	can_double_jump = true
	can_dash = true

func disable_ability():
	if can_dash:
		can_dash = false
	elif can_double_jump:
		can_double_jump = false

# Checkpoint system integration
func respawn_at_checkpoint():
	if SceneManager.has_checkpoint():
		SceneManager.respawn_player(self)
		# Reset any player state if needed
		velocity = Vector2.ZERO
		jump_count = 0
		is_dashing = false
	else:
		print("No checkpoint available for respawn")

# Call this when player dies or needs to respawn
func die():
	print("Player died - respawning at checkpoint")
	respawn_at_checkpoint()
