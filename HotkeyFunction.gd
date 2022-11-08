extends Node

export var hotkeySignal = ""

signal Hotkey_Activated

func activate():
	emit_signal("Hotkey_Activated", hotkeySignal)
	print("Hotkey activated: " + hotkeySignal)
