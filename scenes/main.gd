extends Node

func _ready():
	# Load the main menu when the game starts
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
