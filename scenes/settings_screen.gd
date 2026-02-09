extends Control

@onready var text_size_option: OptionButton = $PageCenter/Margin/Layout/TextSizeRow/TextSizeOption
@onready var high_contrast_toggle: CheckButton = $PageCenter/Margin/Layout/HighContrastRow/HighContrastToggle
@onready var sound_toggle: CheckButton = $PageCenter/Margin/Layout/SoundRow/SoundToggle
@onready var reduce_motion_toggle: CheckButton = $PageCenter/Margin/Layout/ReduceMotionRow/ReduceMotionToggle
@onready var back_button: Button = $PageCenter/Margin/Layout/BackButton

func _ready() -> void:
	# Populate dropdown
	text_size_option.clear()
	text_size_option.add_item("Small", 0)
	text_size_option.add_item("Normal", 1)
	text_size_option.add_item("Large", 2)

	# Set current UI from Settings
	_sync_from_settings()

	# Connect signals
	text_size_option.item_selected.connect(_on_text_size_selected)
	high_contrast_toggle.toggled.connect(func(v): Settings.set_high_contrast(v))
	sound_toggle.toggled.connect(func(v): Settings.set_sound_enabled(v))
	reduce_motion_toggle.toggled.connect(func(v): Settings.set_reduce_motion(v))
	back_button.pressed.connect(_on_back_pressed)

func _sync_from_settings() -> void:
	high_contrast_toggle.button_pressed = Settings.high_contrast
	sound_toggle.button_pressed = Settings.sound_enabled
	reduce_motion_toggle.button_pressed = Settings.reduce_motion

	# Select dropdown based on scale
	if Settings.text_scale <= 0.9:
		text_size_option.select(0)
	elif Settings.text_scale >= 1.2:
		text_size_option.select(2)
	else:
		text_size_option.select(1)

func _on_text_size_selected(index: int) -> void:
	match index:
		0: Settings.set_text_scale(0.9)
		1: Settings.set_text_scale(1.0)
		2: Settings.set_text_scale(1.25)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
