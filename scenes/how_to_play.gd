extends Control

@onready var play_now_button: Button = $Margin/Layout/ButtonWrap/ButtonColumn/PlayNowButton
@onready var back_button: Button = $Margin/Layout/ButtonWrap/ButtonColumn/BackButton
@onready var background: ColorRect = $Background

func _ready() -> void:
	play_now_button.pressed.connect(_on_play_now_pressed)
	back_button.pressed.connect(_on_back_pressed)

	if not Settings.changed.is_connected(apply_accessibility):
		Settings.changed.connect(apply_accessibility)

	apply_accessibility()

func _on_play_now_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func apply_accessibility() -> void:
	UITheme.apply_theme(self)
