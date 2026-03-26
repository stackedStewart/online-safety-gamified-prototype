extends Control

@onready var text_size_option: OptionButton = $PageCenter/Margin/Layout/TextSizeRow/TextSizeOption
@onready var high_contrast_toggle: CheckButton = $PageCenter/Margin/Layout/HighContrastRow/HighContrastToggle
@onready var sound_toggle: CheckButton = $PageCenter/Margin/Layout/SoundRow/SoundToggle
@onready var reduce_motion_toggle: CheckButton = $PageCenter/Margin/Layout/ReduceMotionRow/ReduceMotionToggle
@onready var back_button: Button = $PageCenter/Margin/Layout/BackButton

func _ready() -> void:
	# Connect UI signals first
	text_size_option.item_selected.connect(_on_text_size_selected)
	high_contrast_toggle.toggled.connect(_on_high_contrast_toggled)
	sound_toggle.toggled.connect(_on_sound_toggled)
	reduce_motion_toggle.toggled.connect(_on_reduce_motion_toggled)
	back_button.pressed.connect(_on_back_pressed)

	# Populate dropdown
	text_size_option.clear()
	text_size_option.add_item("Normal", 0)
	text_size_option.add_item("Large", 1)
	text_size_option.add_item("Extra Large", 2)

	# Keep UI in sync if Settings change (guard against double connect)
	if not Settings.changed.is_connected(_on_settings_changed):
		Settings.changed.connect(_on_settings_changed)

	# Sync UI from Settings, then apply visuals (contrast + scaling)
	_sync_from_settings()
	apply_accessibility()

func _on_settings_changed() -> void:
	_sync_from_settings()
	apply_accessibility()

func _sync_from_settings() -> void:
	high_contrast_toggle.button_pressed = Settings.high_contrast
	sound_toggle.button_pressed = Settings.sound_enabled
	reduce_motion_toggle.button_pressed = Settings.reduce_motion

	# Select dropdown based on scale
	if Settings.text_scale <= 1.0:
		text_size_option.select(0)
	elif Settings.text_scale >= 1.3:
		text_size_option.select(2)
	else:
		text_size_option.select(1)

func _on_text_size_selected(index: int) -> void:
	match index:
		0: Settings.set_text_scale(1.0)
		1: Settings.set_text_scale(1.2)
		2: Settings.set_text_scale(1.3)

func _on_high_contrast_toggled(value: bool) -> void:
	Settings.set_high_contrast(value)

func _on_sound_toggled(value: bool) -> void:
	Settings.set_sound_enabled(value)

func _on_reduce_motion_toggled(value: bool) -> void:
	Settings.set_reduce_motion(value)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func apply_accessibility() -> void:
	# Apply theme scaling (fonts + spacing + padding)
	UITheme.apply_theme(self)
