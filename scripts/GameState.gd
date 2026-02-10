extends Node

# --- Progress / scoring ---
var xp: int = 0
var score: int = 0
var correct_count: int = 0
var total_answered: int = 0

# --- Scenario tracking ---
var current_question_index: int = 0

# --- Last result (useful for Results / UX) ---
var last_was_correct: bool = false
var last_feedback: String = ""
var last_xp_earned: int = 0

func reset_run() -> void:
	# Resets progress for a new play session
	xp = 0
	score = 0
	correct_count = 0
	total_answered = 0
	current_question_index = 0
	last_was_correct = false
	last_feedback = ""
	last_xp_earned = 0

func apply_answer(is_correct: bool, feedback_text: String, xp_correct: int = 10, xp_wrong: int = 5) -> void:
	# Call this when the player answers a scenario
	total_answered += 1
	last_was_correct = is_correct
	last_feedback = feedback_text

	if is_correct:
		correct_count += 1
		last_xp_earned = xp_correct
	else:
		last_xp_earned = xp_wrong

	xp += last_xp_earned
	score = xp # simple mapping for now; can change later
