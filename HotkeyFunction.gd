extends Node

export var hotkeySignal = ""

signal Hotkey_Activated

func activate():
	emit_signal("Hotkey_Activated", hotkeySignal)
	print("Hotkey activated: " + hotkeySignal)
	
func _ready():
	var playback_node = get_node("/root/Main2/Gwidi_Playback")
	if(playback_node != null):
		connect("Hotkey_Activated", playback_node, "_on_hotkey_activated")
