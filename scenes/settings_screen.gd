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
	text_size_option.add_item("Small", 0)
	text_size_option.add_item("Normal", 1)
	text_size_option.add_item("Large", 2)

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
	# Background (optional)
	var bg := get_node_or_null("Background")
	if bg != null and bg is ColorRect:
		(bg as ColorRect).color = Color("#000000") if Settings.high_contrast else Color("#6FD3FF")

	# Text scaling (always)
	apply_text_scaling(self)


func apply_text_scaling(root: Node) -> void:
	_apply_text_scaling_recursive(root)

func _apply_text_scaling_recursive(node: Node) -> void:
	if node is Control:
		var c := node as Control

		# Only apply to controls that actually render text
		if c is Label or c is Button or c is CheckButton or c is OptionButton or c is RichTextLabel:
			var meta_key := "base_font_size"

			# Store the original size once
			if not c.has_meta(meta_key):
				var base := c.get_theme_font_size("font_size")
				if base > 0:
					c.set_meta(meta_key, base)

			# Apply scaled size
			if c.has_meta(meta_key):
				var base_size: int = int(c.get_meta(meta_key))
				var new_size: int = int(round(base_size * Settings.text_scale))
				c.add_theme_font_size_override("font_size", new_size)

				# OptionButton has a dropdown popup that needs scaling too
				if c is OptionButton:
					var popup := (c as OptionButton).get_popup()
					if popup != null:
						popup.add_theme_font_size_override("font_size", new_size)

	# Recurse
	for child in node.get_children():
		_apply_text_scaling_recursive(child)
