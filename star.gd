extends Node2D

@onready var area_2d = $Area2D
@onready var sprite_2d = $Sprite2D

var is_collected = false

func _ready():
	# Connect the area signal
	area_2d.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body):
	if body.name == "Player" and not is_collected:
		collect_star()

func collect_star():
	is_collected = true
	
	# Add to global star count
	StarManager.add_star()
	
	# Play collection sound
	var audio_manager = get_node("/root/AudioManager")
	if audio_manager:
		audio_manager.play_star_sound()
	
	# Play collection animation/effect
	var tween = create_tween()
	tween.parallel().tween_property(sprite_2d, "scale", Vector2(1.5, 1.5), 0.2)
	tween.parallel().tween_property(sprite_2d, "modulate", Color(1, 1, 1, 0), 0.2)
	
	# Remove the star after animation
	await tween.finished
	queue_free()
