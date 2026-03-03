extends Control

@onready var play_button: Button = $CenterContainer/Margin/Layout/MenuCard/Buttons/PlayButton
@onready var settings_button: Button = $CenterContainer/Margin/Layout/MenuCard/Buttons/SettingsButton

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
	
	# Background (optional)
	var bg := get_node_or_null("Background")
	if bg != null and bg is ColorRect:
		(bg as ColorRect).color = Color("#000000") if Settings.high_contrast else Color("#AEE6FF")
		
	UITheme.apply_theme(self)
	
	var title := $CenterContainer/Margin/Layout/Header/TitleWrap/TitleBanner/TitleLabel
	if title:
		title.add_theme_font_size_override("font_size", int(36 * Settings.text_scale))
	
