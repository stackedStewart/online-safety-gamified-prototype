extends Control

@onready var play_button: Button = $CenterContainer/Margin/Layout/Buttons/PlayButton
@onready var settings_button: Button = $CenterContainer/Margin/Layout/Buttons/SettingsButton

func _ready() -> void:
	# Button signals (code-based connection)
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

	# Apply accessibility now + whenever Settings change
	Settings.changed.connect(apply_accessibility)
	apply_accessibility()

func _on_play_pressed() -> void:
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_screen.tscn")

func apply_accessibility() -> void:
	# Safe: avoids null-instance crashes if Background is missing/renamed
	var bg := get_node_or_null("Background")
	if bg == null:
		return
	if bg is ColorRect:
		(bg as ColorRect).color = Color("#000000") if Settings.high_contrast else Color("#6FD3FF")
