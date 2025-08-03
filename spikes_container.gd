extends Node2D

# This node will contain all spikes in the level
# Any spike added as a child will automatically work with the checkpoint system

func _ready():
	# Make sure all spike children have proper setup
	for child in get_children():
		if child.has_method("_on_area_2d_body_entered"):
			print("Spike child properly configured: ", child.name)
