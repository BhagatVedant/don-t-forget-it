extends Node2D

@onready var area_2d = $Area2D
@onready var sprite_2d = $Sprite2D

var is_activated = false
var spawn_position: Vector2

func _ready():
	# Set spawn position to this checkpoint's position
	spawn_position = global_position
	
	# Connect the area signal
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	
	# Start with frame 0 (inactive checkpoint)
	sprite_2d.frame = 0

func _on_area_2d_body_entered(body):
	if body.name == "Player" and not is_activated:
		activate_checkpoint()

func activate_checkpoint():
	is_activated = true
	
	# Change to frame 1 (activated checkpoint)
	sprite_2d.frame = 1
	
	# Set this as the current spawn point (you can add a global checkpoint manager)
	set_as_current_spawn_point()
	
	print("Checkpoint activated at position: ", global_position)

func set_as_current_spawn_point():
	# Use the global SceneManager to set this checkpoint
	SceneManager.set_current_checkpoint(self)

func get_spawn_position() -> Vector2:
	return spawn_position
