extends Node

# Audio nodes
@onready var bgm_player = $BGMPlayer
@onready var sfx_player = $SFXPlayer

# Audio resources
var swoosh_sound: AudioStream
var bgm_mushroom: AudioStream  
var win_sound: AudioStream

func _ready():
	# Load audio resources
	swoosh_sound = load("res://Audio/269288__kwahmah_02__swoosh26.wav")
	bgm_mushroom = load("res://Audio/415804__sunsai__mushroom-background-music.wav")
	win_sound = load("res://Audio/535840__evretro__8-bit-mini-win-sound-effect.wav")
	
	print("Audio resources loaded:")
	print("- Swoosh: ", swoosh_sound != null)
	print("- BGM: ", bgm_mushroom != null) 
	print("- Win: ", win_sound != null)
	
	# Connect BGM finished signal for looping
	if bgm_player:
		bgm_player.finished.connect(_on_bgm_finished)
	
	# Start background music
	play_bgm()

func _on_bgm_finished():
	# Restart the background music when it finishes
	if bgm_player and bgm_mushroom:
		bgm_player.play()

func play_bgm():
	if bgm_player and bgm_mushroom:
		bgm_player.stream = bgm_mushroom
		bgm_player.volume_db = -10  # Adjust volume as needed
		bgm_player.play()
		print("Background music started")

func play_dash_sound():
	if sfx_player and swoosh_sound:
		sfx_player.stream = swoosh_sound
		sfx_player.volume_db = -5  # Adjust volume as needed
		sfx_player.play()
		print("Dash sound played")

func play_checkpoint_sound():
	if sfx_player and win_sound:
		sfx_player.stream = win_sound
		sfx_player.volume_db = -8  # Adjust volume as needed
		sfx_player.play()
		print("Checkpoint sound played")

func play_star_sound():
	if sfx_player and win_sound:
		sfx_player.stream = win_sound
		sfx_player.volume_db = -12  # Quieter for star collection
		sfx_player.play()
		print("Star sound played")

func stop_bgm():
	if bgm_player:
		bgm_player.stop()

func set_bgm_volume(volume_db: float):
	if bgm_player:
		bgm_player.volume_db = volume_db

func set_sfx_volume(volume_db: float):
	if sfx_player:
		sfx_player.volume_db = volume_db
