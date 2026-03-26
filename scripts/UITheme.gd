extends Node

const THEME_DEFAULT := "res://ui/themes/theme_default.tres"
const THEME_CONTRAST := "res://ui/themes/theme_high_contrast.tres"

# Base design tokens
const BASE_FONT := 26
const BASE_BUTTON_HEIGHT := 82
const BASE_SEPARATION := 5
const BASE_CARD_PADDING := 24
const BASE_SCREEN_MARGIN := 36  # NEW

# Clamp limits (to prevent overflow at Extra Large)
const MAX_BUTTON_HEIGHT := 80
const MAX_SEPARATION := 15
const MAX_CARD_PADDING := 22
const MAX_SCREEN_MARGIN := 30    # NEW
const MAX_TITLE_FONT := 40
const MAX_HUD_FONT := 48

const TITLE_MULT := 1.35
const HUD_MULT := 1.15

func apply_theme(root: Control) -> void:
	var path := THEME_CONTRAST if Settings.high_contrast else THEME_DEFAULT
	var base_theme: Theme = load(path)
	var t: Theme = base_theme.duplicate(true)
	var s := Settings.text_scale

	# --- Base font scaling (global defaults) ---
	_set_font_size(t, "Label", int(round(BASE_FONT * s)))
	_set_font_size(t, "Button", int(round((BASE_FONT - 2) * s)))
	_set_font_size(t, "CheckButton", int(round(BASE_FONT * s)))
	_set_font_size(t, "OptionButton", int(round(BASE_FONT * s)))

	# --- Separation (clamped) ---
	var sep := int(round(BASE_SEPARATION * s))
	sep = min(sep, MAX_SEPARATION)
	t.set_constant("separation", "VBoxContainer", sep)
	t.set_constant("separation", "HBoxContainer", sep)

	# --- Button height (clamped) ---
	var viewport_h := root.get_viewport_rect().size.y
	
	var ideal_btn_h := int(round(BASE_BUTTON_HEIGHT * s))
	var safe_btn_h = min(ideal_btn_h, MAX_BUTTON_HEIGHT)
	
	if s >= 1.3 and viewport_h <= 720:
		safe_btn_h = min(safe_btn_h, 84)
		
	t.set_constant("min_height", "Button", safe_btn_h)

	# --- PanelContainer padding (clamped) ---
	var pad := int(round(BASE_CARD_PADDING * s))
	pad = min(pad, MAX_CARD_PADDING)
	_scale_panel_padding(t, pad)

	# --- MarginContainer margins (NEW, clamped) ---
	var m := int(round(BASE_SCREEN_MARGIN * s))
	m = min(m, MAX_SCREEN_MARGIN)
	_set_margin_container_margins(t, m)

	root.theme = t
	_apply_group_font_overrides(root, s)
	_apply_screen_background(root)
	_apply_overlay_contrast(root)

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

func _set_margin_container_margins(t: Theme, m: int) -> void:
	t.set_constant("margin_left", "MarginContainer", m)
	t.set_constant("margin_right", "MarginContainer", m)
	t.set_constant("margin_top", "MarginContainer", m)
	t.set_constant("margin_bottom", "MarginContainer", m)

func _apply_group_font_overrides(root: Node, s: float) -> void:
	var base := int(round(BASE_FONT * s))

	var title_size := int(round(base * TITLE_MULT))
	title_size = min(title_size, MAX_TITLE_FONT)

	var hud_size := int(round(base * HUD_MULT))
	hud_size = min(hud_size, MAX_HUD_FONT)

	for n in root.get_tree().get_nodes_in_group("ui_title"):
		if root.is_ancestor_of(n) and n is Control:
			_set_control_font_size(n as Control, title_size)

	for n in root.get_tree().get_nodes_in_group("ui_hud"):
		if root.is_ancestor_of(n) and n is Control:
			_set_control_font_size(n as Control, hud_size)

func _set_control_font_size(c: Control, size: int) -> void:
	c.remove_theme_font_size_override("font_size")
	c.add_theme_font_size_override("font_size", size)
	
func _apply_screen_background(root: Control) -> void:
	var bg := root.get_node_or_null("Background")
	if bg != null and bg is ColorRect:
		(bg as ColorRect).color = Color.BLACK if Settings.high_contrast else Color("#67c4dd")

func _apply_overlay_contrast(root: Control) -> void:
	var dimmer := root.get_node_or_null("FeedbackOverlay/Dimmer")
	if dimmer != null and dimmer is ColorRect:
		if Settings.high_contrast:
			(dimmer as ColorRect).color = Color(0, 0, 0, 0.35)
		else:
			(dimmer as ColorRect).color = Color(0.0, 0.0, 0.0, 0.45)
