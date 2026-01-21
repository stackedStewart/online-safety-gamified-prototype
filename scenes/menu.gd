extends Control

func _ready():
	print("GameState loaded. XP = ", GameState.xp)
	$CenterContainer/Margin/Layout/Buttons/PlayButton.pressed.connect(_on_play_pressed)
	

func _on_play_pressed():
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")
