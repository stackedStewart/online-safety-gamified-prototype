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

	# Keep UI in sync if Settings change elsewhere
	Settings.changed.connect(_on_settings_changed)

	# Apply background accessibility on load
	apply_accessibility()

	# Connect signals
	text_size_option.item_selected.connect(_on_text_size_selected)
	high_contrast_toggle.toggled.connect(_on_high_contrast_toggled)
	sound_toggle.toggled.connect(_on_sound_toggled)
	reduce_motion_toggle.toggled.connect(_on_reduce_motion_toggled)
	back_button.pressed.connect(_on_back_pressed)

func _on_settings_changed() -> void:
	_sync_from_settings()
	apply_accessibility()

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

func _on_high_contrast_toggled(value: bool) -> void:
	Settings.set_high_contrast(value)

func _on_sound_toggled(value: bool) -> void:
	Settings.set_sound_enabled(value)

func _on_reduce_motion_toggled(value: bool) -> void:
	Settings.set_reduce_motion(value)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func apply_accessibility() -> void:
	# Optional: if your Settings scene has a Background ColorRect named "Background"
	var bg := get_node_or_null("Background")
	if bg == null:
		return
	if bg is ColorRect:
		(bg as ColorRect).color = Color("#000000") if Settings.high_contrast else Color("#6FD3FF")
