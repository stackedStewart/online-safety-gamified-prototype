extends Control

@onready var play_button: Button = $CenterContainer/Margin/Layout/Buttons/PlayButton
@onready var settings_button: Button = $CenterContainer/Margin/Layout/Buttons/SettingsButton

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
		(bg as ColorRect).color = Color("#000000") if Settings.high_contrast else Color("#6FD3FF")

	# Text scaling (always)
	apply_text_scaling(self)

func apply_text_scaling(root: Node) -> void:
	_apply_text_scaling_recursive(root)

func _apply_text_scaling_recursive(node: Node) -> void:
	if node is Control:
		var c := node as Control

		if c is Label or c is Button or c is CheckButton or c is OptionButton or c is RichTextLabel:
			var meta_key := "base_font_size"

			if not c.has_meta(meta_key):
				var base := c.get_theme_font_size("font_size")
				if base > 0:
					c.set_meta(meta_key, base)

			if c.has_meta(meta_key):
				var base_size: int = int(c.get_meta(meta_key))
				var new_size: int = int(round(base_size * Settings.text_scale))
				c.add_theme_font_size_override("font_size", new_size)

				# OptionButton popup needs scaling too
				if c is OptionButton:
					var popup := (c as OptionButton).get_popup()
					if popup != null:
						popup.add_theme_font_size_override("font_size", new_size)

	for child in node.get_children():
		_apply_text_scaling_recursive(child)
