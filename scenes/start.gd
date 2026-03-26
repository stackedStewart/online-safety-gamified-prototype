extends Control

@onready var start_button: Button = $Margin/Layout/ButtonWrap/StartButton
@onready var background: ColorRect = $Background

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)

	if not Settings.changed.is_connected(apply_accessibility):
		Settings.changed.connect(apply_accessibility)

	apply_accessibility()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func apply_accessibility() -> void:
	UITheme.apply_theme(self)
