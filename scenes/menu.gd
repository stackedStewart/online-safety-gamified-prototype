extends Control

@onready var play_button: Button = $Margin/Layout/ButtonWrap/ButtonColumn/PlayButton
@onready var how_to_play_button: Button = $Margin/Layout/ButtonWrap/ButtonColumn/HowToPlayButton
@onready var settings_button: Button = $Margin/Layout/ButtonWrap/ButtonColumn/SettingsButton
@onready var back_button: Button = $Margin/Layout/ButtonWrap/ButtonColumn/BackButton
@onready var background: ColorRect = $Background

func _ready() -> void:
	# Button signals (code-based connection)
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	back_button.pressed.connect(_on_back_pressed)
	how_to_play_button.pressed.connect(_on_how_to_play_pressed)

	# Apply accessibility now + whenever Settings change
	Settings.changed.connect(apply_accessibility)
	apply_accessibility()

func _on_play_pressed() -> void:
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")
	
func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/how_to_play.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_screen.tscn")
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")


func apply_accessibility() -> void:
	UITheme.apply_theme(self)
	
	# Background (optional)
	var bg := get_node_or_null("Background")
	if bg != null and bg is ColorRect:
		(bg as ColorRect).color = Color("#000000") if Settings.high_contrast else Color("#67c4dd")
		
	
	
	var title := $Margin/Layout/NinePatchRect/TitleLabel
	if title:
		title.add_theme_font_size_override("font_size", int(36 * Settings.text_scale))
	
	
