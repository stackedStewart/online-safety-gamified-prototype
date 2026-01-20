extends Control

func _ready():
	$Margin/Layout/Buttons/NextChallengeButton.pressed.connect(_on_next_pressed)
	$Margin/Layout/Buttons/BackToMenuButton.pressed.connect(_on_back_pressed)

func _on_next_pressed():
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
