extends Control

@export var form_url: String = "https://forms.gle/v3eMkdbtCAHxm92W7"

@onready var open_form_button: Button = $CenterContainer/Panel/PanelMargin/PanelLayout/OpenFormButton
@onready var close_button: Button = $CenterContainer/Panel/PanelMargin/PanelLayout/CloseButton

func _ready() -> void:
	open_form_button.pressed.connect(_on_open_form_pressed)
	close_button.pressed.connect(_on_close_pressed)

func show_overlay() -> void:
	visible = true

func hide_overlay() -> void:
	visible = false

func _on_open_form_pressed() -> void:
	if form_url.strip_edges() != "":
		OS.shell_open(form_url)

func _on_close_pressed() -> void:
	hide_overlay()
