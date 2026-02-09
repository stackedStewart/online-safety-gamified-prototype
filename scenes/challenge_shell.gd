extends Control

const SCENARIO_PATH := "res://data/scenarios/scenarios.json"

var scenarios: Array = []
var current_index: int = 0
var awaiting_next: bool = false

# --- Page / main UI (now under PageContainer) ---
@onready var back_button: Button = $PageContainer/Margin/Layout/TopBar/BackButton
@onready var xp_label: Label = $PageContainer/Margin/Layout/TopBar/XPLabel
@onready var question_counter_label: Label = $PageContainer/Margin/Layout/TopBar/QuestionCounterLabel
@onready var scenario_label: Label = $PageContainer/Margin/Layout/ScenarioCard/ScenarioMargin/ScenarioLabel
@onready var option_a: Button = $PageContainer/Margin/Layout/Options/OptionAButton
@onready var option_b: Button = $PageContainer/Margin/Layout/Options/OptionBButton
@onready var option_c: Button = $PageContainer/Margin/Layout/Options/OptionCButton

# --- Feedback overlay (unchanged) ---
@onready var overlay: Control = $FeedbackOverlay
@onready var feedback_title: Label = $FeedbackOverlay/CenterContainer/FeedbackPanel/FeedbackMargin/FeedbackLayout/FeedbackTitle
@onready var feedback_text: Label = $FeedbackOverlay/CenterContainer/FeedbackPanel/FeedbackMargin/FeedbackLayout/FeedbackText
@onready var next_button: Button = $FeedbackOverlay/CenterContainer/FeedbackPanel/FeedbackMargin/FeedbackLayout/NextButton

func _ready() -> void:
	Settings.changed.connect(apply_accessibility)
	apply_accessibility()
	overlay.visible = false

	back_button.pressed.connect(_on_back_pressed)
	option_a.pressed.connect(func(): _on_option_pressed(0))
	option_b.pressed.connect(func(): _on_option_pressed(1))
	option_c.pressed.connect(func(): _on_option_pressed(2))
	next_button.pressed.connect(_on_next_pressed)

	_load_scenarios()
	current_index = GameState.current_question_index
	_show_current()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _load_scenarios() -> void:
	var file := FileAccess.open(SCENARIO_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open scenarios file: %s" % SCENARIO_PATH)
		return

	var text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var result := json.parse(text)
	if result != OK:
		push_error("JSON parse error at line %d: %s" % [json.get_error_line(), json.get_error_message()])
		return

	var root = json.data
	if typeof(root) != TYPE_DICTIONARY or not root.has("scenarios"):
		push_error("Invalid scenarios JSON format: expected {\"scenarios\": [...]}")
		return

	scenarios = root["scenarios"]

func _show_current() -> void:
	if scenarios.is_empty():
		question_counter_label.text = "Q 0 / 0"
		scenario_label.text = "No scenarios loaded."
		option_a.disabled = true
		option_b.disabled = true
		option_c.disabled = true
		return

	current_index = clamp(current_index, 0, scenarios.size() - 1)
	GameState.current_question_index = current_index

	var s: Dictionary = scenarios[current_index]

	scenario_label.text = str(s.get("prompt", ""))
	var opts: Array = s.get("options", [])
	option_a.text = str(opts[0]) if opts.size() > 0 else "Option A"
	option_b.text = str(opts[1]) if opts.size() > 1 else "Option B"
	option_c.text = str(opts[2]) if opts.size() > 2 else "Option C"

	option_a.disabled = false
	option_b.disabled = false
	option_c.disabled = false
	awaiting_next = false

	_update_xp()
	_update_question_counter()

func _update_xp() -> void:
	xp_label.text = "XP: %d" % GameState.xp

func _on_option_pressed(chosen_index: int) -> void:
	if awaiting_next:
		return

	var s: Dictionary = scenarios[current_index]
	var correct_index: int = int(s.get("correct_index", 0))
	var is_correct := chosen_index == correct_index

	var correct_msg := str(s.get("feedback_correct", "Well done!"))
	var wrong_msg := str(s.get("feedback_wrong", "Nice try!"))
	var feedback := correct_msg if is_correct else wrong_msg

	GameState.apply_answer(is_correct, feedback)

	feedback_title.text = "⭐ Great job!" if is_correct else "🙂 Nice try!"
	feedback_text.text = feedback
	overlay.visible = true

	option_a.disabled = true
	option_b.disabled = true
	option_c.disabled = true
	awaiting_next = true

	_update_xp()

func _on_next_pressed() -> void:
	overlay.visible = false

	current_index += 1
	GameState.current_question_index = current_index

	if current_index >= scenarios.size():
		get_tree().change_scene_to_file("res://scenes/results.tscn")
		return

	_show_current()
	
	
func _update_question_counter() -> void:
	var total := scenarios.size()
	var current := current_index + 1 # humans start at 1
	#question_counter_label.text = "Q %d / %d" % [current, total]
	question_counter_label.text = "Question %d of %d" % [current, total]
	
func apply_accessibility() -> void:
	# Example: change background colour
	var bg: ColorRect = $Background # adjust if node name differs

	if Settings.high_contrast:
		bg.color = Color("#000000")
	else:
		bg.color = Color("#6FD3FF")

	# Example: scale key labels/buttons using font sizes
	# (Set base sizes then multiply by Settings.text_scale)
