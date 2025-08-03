extends Node2D

@onready var player = $Player
@onready var dialogue_box = $DialogueBox
@onready var tutorial_ui = $TutorialUI
@onready var fade_overlay = $FadeOverlay
@onready var bg_node = $bg
@onready var black_bg = $black
@onready var tutorial_sound = $Audio/TutorialCompleteSound
@onready var tile_map = $TileMapLayer
@onready var tutorial_areas = $Node2D
@onready var tutorial_arrows = $"tutorial arrows"

var abilities_at_memory_point = {
	"can_double_jump": true,
	"can_dash": true
}

var tutorial_step = 0
var tutorial_steps = [
	"Use A and D keys to move left and right",
	"Press SPACE to jump", 
	"Press E to dash",
	"Well done! You've mastered the basic controls!"
]

func _ready():
	player.set_physics_process(false)
	
	# Make sure tutorial_ui is ready before hiding
	if tutorial_ui:
		tutorial_ui.hide()
	
	# Start cutscene
	start_cutscene()

func start_cutscene():
	# Create dark background for cutscene
	black_bg.color = Color(0.05, 0.05, 0.2, 1.0)  # Dark blue background
	bg_node.modulate.a = 0.3  # Dim the normal background
	tile_map.visible = false  # Hide tiles during cutscene
	tutorial_areas.visible = false  # Hide tutorial trigger areas during cutscene
	tutorial_arrows.visible = false  # Hide tutorial arrows during cutscene
	
	# Position player in center for cutscene
	player.position.x = 480  # Center of screen (960/2)
	player.position.y = 200  # Middle height
	player.disable_input()
	
	# Start dialogue with faster prompt timing
	dialogue_box.start_dialogue("cannot remember... ugh...")
	await dialogue_box.dialogue_finished
	
	# Quick pause before fade
	await get_tree().create_timer(0.3).timeout
	
	# White fade out (faster)
	fade_to_white()
	await get_tree().create_timer(0.8).timeout
	
	# Reset background and move player to starting position
	black_bg.color = Color(0, 0, 0, 0.196078)  # Back to normal
	bg_node.modulate.a = 1.0  # Restore normal background
	tile_map.visible = true  # Show tiles again
	tutorial_areas.visible = true  # Show tutorial areas for gameplay
	tutorial_arrows.visible = true  # Show tutorial arrows for guidance 
	player.position.x = 64
	player.position.y = 320  # Ground level
	
	# Fade back in (faster)
	fade_from_white()
	await get_tree().create_timer(0.8).timeout
	
	# Start tutorial
	start_tutorial()

func fade_to_white():
	var tween = create_tween()
	tween.tween_property(fade_overlay.get_child(0), "color", Color(1, 1, 1, 1), 0.4)

func fade_from_white():
	var tween = create_tween()
	tween.tween_property(fade_overlay.get_child(0), "color", Color(1, 1, 1, 0), 0.4)

func start_tutorial():
	player.set_physics_process(true)
	tutorial_step = 0
	player.set_tutorial_step(0)  # Start with movement only
	show_tutorial_step()

func show_tutorial_step():
	if tutorial_step < tutorial_steps.size():
		if tutorial_ui:
			tutorial_ui.show_step(tutorial_steps[tutorial_step])
		
		# If this is the final step (well done message), start fade timer
		if tutorial_step == tutorial_steps.size() - 1:
			_start_final_message_timer()
	else:
		if tutorial_ui:
			tutorial_ui.hide()
		player.enable_input()  # Full input enabled after tutorial

func _start_final_message_timer():
	# Create a separate timer for the final message fade
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(_fade_final_message)
	player.enable_input()  # Enable input immediately for final step

func _fade_final_message():
	if tutorial_ui:
		tutorial_ui.fade_out()

func next_tutorial_step():
	# Play completion sound
	tutorial_sound.play()
	
	tutorial_step += 1
	player.set_tutorial_step(tutorial_step)  # Update player's allowed inputs
	show_tutorial_step()

func _on_move_body_entered(body):
	if body.name == "Player" and tutorial_step == 0:
		next_tutorial_step()

func _on_jump_body_entered(body):
	if body.name == "Player" and tutorial_step == 1:
		next_tutorial_step()

func _on_dash_body_entered(body):
	if body.name == "Player" and tutorial_step == 2:
		next_tutorial_step()

func _on_DialogueBox_dialogue_finished():
	pass
