extends Node

var click_sound: AudioStream = preload("res://assets/audio/sfx/click-a.ogg")
var correct_sound: AudioStream = preload("res://assets/audio/sfx/confirmation_002.ogg")
var incorrect_sound: AudioStream = preload("res://assets/audio/sfx/error_008.ogg")

func play_click() -> void:
	_play_stream(click_sound)

func play_correct() -> void:
	_play_stream(correct_sound)

func play_incorrect() -> void:
	_play_stream(incorrect_sound)

func _play_stream(stream: AudioStream) -> void:
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "SFX"
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
