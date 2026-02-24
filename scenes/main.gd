extends Node

func _ready() -> void:
	call_deferred("_go_to_menu")

func _go_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
