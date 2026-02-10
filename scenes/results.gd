extends Control

@onready var title_label: Label = $PageCenter/Margin/Layout/TitleLabel

@onready var xp_label: Label = $PageCenter/Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/XPLabel
@onready var badge_label: Label = $PageCenter/Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/BadgeLabel
@onready var reminder_label: Label = $PageCenter/Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/ReminderLabel

@onready var try_again_button: Button = $PageCenter/Margin/Layout/Buttons/NextChallengeButton
@onready var back_to_menu_button: Button = $PageCenter/Margin/Layout/Buttons/BackToMenuButton

func _ready() -> void:
	Settings.changed.connect(apply_accessibility)
	apply_accessibility()

	title_label.text = "Results"

	var xp: int = GameState.xp
	var correct: int = GameState.correct_count
	var total: int = max(1, GameState.total_answered)
	var accuracy := int(round((float(correct) / float(total)) * 100.0))

	xp_label.text = "XP earned: %d" % xp
	badge_label.text = "Correct answers: %d / %d (%d%%)" % [correct, total, accuracy]
	reminder_label.text = _message_for_score(correct, total)

	try_again_button.text = "Try again"
	back_to_menu_button.text = "Back to menu"

	try_again_button.pressed.connect(_on_try_again)
	back_to_menu_button.pressed.connect(_on_back_to_menu)

func _message_for_score(correct: int, total: int) -> String:
	if correct >= total:
		return "🏆 Online Safety Star!\nAmazing! If you're not sure, tell a trusted adult."
	elif correct >= int(ceil(total * 0.75)):
		return "⭐ Safety Hero!\nGreat job! If you're not sure, tell a trusted adult."
	elif correct >= int(ceil(total * 0.5)):
		return "🙂 Safety Learner!\nGood effort! Take your time and think it through."
	else:
		return "🌱 Getting Started!\nNice try! Let's practise again — tell a trusted adult if unsure."

func _on_try_again() -> void:
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")

func _on_back_to_menu() -> void:
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
