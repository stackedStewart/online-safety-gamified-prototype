extends Node

const THEME_DEFAULT := "res://ui/themes/theme_default.tres"
const THEME_CONTRAST := "res://ui/themes/theme_high_contrast.tres"

# Base design tokens (tweak once here)
const BASE_FONT := 24
const BASE_BUTTON_HEIGHT := 72
const BASE_SEPARATION := 18
const BASE_CARD_PADDING := 20

func apply_theme(root: Control) -> void:
	var path := THEME_CONTRAST if Settings.high_contrast else THEME_DEFAULT
	var base_theme: Theme = load(path)

	# Duplicate so we don't modify the .tres on disk
	var t: Theme = base_theme.duplicate(true)

	var s := Settings.text_scale

	# Fonts
	_set_font_size(t, "Label", int(round(BASE_FONT * s)))
	_set_font_size(t, "Button", int(round(BASE_FONT - 2)))
	_set_font_size(t, "CheckButton", int(round(BASE_FONT * s)))
	_set_font_size(t, "OptionButton", int(round(BASE_FONT * s)))

	# Layout constants
	t.set_constant("separation", "VBoxContainer", int(round(BASE_SEPARATION * s)))
	t.set_constant("separation", "HBoxContainer", int(round(BASE_SEPARATION * s)))
	t.set_constant("min_height", "Button", int(round(BASE_BUTTON_HEIGHT * s)))

	# PanelContainer padding
	_scale_panel_padding(t, int(round(BASE_CARD_PADDING * s)))

	root.theme = t

func _set_font_size(t: Theme, type: String, size: int) -> void:
	t.set_font_size("font_size", type, size)

func _scale_panel_padding(t: Theme, pad: int) -> void:
	var sb: StyleBox = t.get_stylebox("panel", "PanelContainer")
	if sb == null:
		return
	var sflat := sb as StyleBoxFlat
	if sflat == null:
		return

	sflat.content_margin_left = pad
	sflat.content_margin_right = pad
	sflat.content_margin_top = pad
	sflat.content_margin_bottom = pad
