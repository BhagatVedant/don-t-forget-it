extends Node2D

func _ready():
	$LoopTimer.timeout.connect(_on_loop_timer_timeout)

func _on_loop_timer_timeout():
	get_tree().reload_current_scene()
