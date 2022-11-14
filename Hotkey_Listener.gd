extends Node

var hotkey_detector

# Called when the node enters the scene tree for the first time.
func _ready():
	hotkey_detector = Gwidi_HotKey.new()
	start_listening()

func start_listening():
	hotkey_detector.beginListening()

func stop_listening():
	hotkey_detector.stopListening()

func assign_hotkey(hotkeyName, f):
	hotkey_detector.assignHotkeyFunction(hotkeyName, f)
