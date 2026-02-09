extends Control

func _ready():
	print("GameState loaded. XP = ", GameState.xp)
	$CenterContainer/Margin/Layout/Buttons/PlayButton.pressed.connect(_on_play_pressed)
	$CenterContainer/Margin/Layout/Buttons/SettingsButton.pressed.connect(_on_settings_pressed)
	

func _on_play_pressed():
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_screen.tscn")
	
func apply_accessibility() -> void:
	# Example: change background colour
	var bg: ColorRect = $Background # adjust if node name differs

	if Settings.high_contrast:
		bg.color = Color("#000000")
	else:
		bg.color = Color("#6FD3FF")

	# Example: scale key labels/buttons using font sizes
	# (Set base sizes then multiply by Settings.text_scale)
