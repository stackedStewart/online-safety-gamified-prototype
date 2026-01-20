extends Control

@onready var back_button = $Margin/Layout/TopBar/BackButton
@onready var finish_button = $Margin/Layout/Options/OptionAButton  # temporary for testing
@onready var feedback_overlay = $FeedbackOverlay

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	
	# TEMP: use first option as a fake "finish" button for now
	finish_button.pressed.connect(_on_finish_pressed)
	
	feedback_overlay.visible = false

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_finish_pressed():
	# For now, jump straight to results
	get_tree().change_scene_to_file("res://scenes/results.tscn")
