extends Control

@onready var title_label: Label = $PageCenter/Margin/Layout/TitleLabel

@onready var xp_label: Label = $PageCenter/Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/XPLabel

@onready var badge_label: Label = $PageCenter/Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/BadgeLabel
@onready var reminder_label: Label = $PageCenter/Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/ReminderLabel

@onready var try_again_button: Button = $PageCenter/Margin/Layout/Buttons/NextChallengeButton
@onready var back_to_menu_button: Button = $PageCenter/Margin/Layout/Buttons/BackToMenuButton

func _ready() -> void:
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
