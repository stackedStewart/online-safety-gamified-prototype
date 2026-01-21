extends Control

@onready var xp_label: Label = $Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/XPLabel
@onready var badge_label: Label = $Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/BadgeLabel
@onready var reminder_label: Label = $Margin/Layout/SummaryCard/SummaryMargin/SummaryLayout/ReminderLabel

func _ready() -> void:
	xp_label.text = "XP earned: %d" % GameState.xp
	badge_label.text = "Correct answers: %d / %d" % [GameState.correct_count, GameState.total_answered]
	reminder_label.text = "Remember: If you're not sure, tell a trusted adult."

	$Margin/Layout/Buttons/NextChallengeButton.pressed.connect(_on_next)
	$Margin/Layout/Buttons/BackToMenuButton.pressed.connect(_on_menu)

func _on_next() -> void:
	# Replay from start for now
	GameState.reset_run()
	get_tree().change_scene_to_file("res://scenes/challenge_shell.tscn")

func _on_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
