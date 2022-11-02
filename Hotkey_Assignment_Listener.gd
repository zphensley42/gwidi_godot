extends Node

var hotkeyDetector = null

# TODO: Hook this up to UI!

# Called when the node enters the scene tree for the first time.
func _ready():
	hotkeyDetector = Gwidi_HotKey.new()

func on_start_listening():
	var f = funcref(self, "on_pressed_keys_updated")
	hotkeyDetector.assignPressedKeyListener(f)
	
	hotkeyDetector.beginListening()

func on_stop_listening():
	hotkeyDetector.stopListening()
	
	# grab the keys we pressed, use them to update our config

func on_pressed_keys_updated():
	var pressedKeys = hotkeyDetector.pressedKeys()
	for key in pressedKeys:
		print("key pressed: " + key["name"] + ", code: " + str(key["key"]))
