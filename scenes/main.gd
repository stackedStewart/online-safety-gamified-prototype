extends Node

# directs to start/splash screen
func _ready() -> void:
	call_deferred("_go_to_start")

func _go_to_start() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")
