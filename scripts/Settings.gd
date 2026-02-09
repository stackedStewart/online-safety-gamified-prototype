extends Node

signal changed

# Accessibility
var text_scale: float = 1.0
var high_contrast: bool = false
var reduce_motion: bool = false

# Audio
var sound_enabled: bool = true

func set_text_scale(value: float) -> void:
	text_scale = value
	emit_signal("changed")

func set_high_contrast(value: bool) -> void:
	high_contrast = value
	emit_signal("changed")

func set_reduce_motion(value: bool) -> void:
	reduce_motion = value
	emit_signal("changed")

func set_sound_enabled(value: bool) -> void:
	sound_enabled = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), not sound_enabled)
	emit_signal("changed")
