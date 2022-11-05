extends Node

var hotkeyDetector = null
var uiUpdateFunc = null

# TODO: Hook this up to UI!

# Called when the node enters the scene tree for the first time.
func _ready():
	hotkeyDetector = Gwidi_HotKey.new()

func start_listening(updateFunc):
	var f = funcref(self, "on_pressed_keys_updated")
	uiUpdateFunc = updateFunc
	hotkeyDetector.assignPressedKeyListener(f)
	hotkeyDetector.beginListening()

func stop_listening():
	hotkeyDetector.stopListening()
	
	var ret = hotkeyDetector.pressedKeys()
	hotkeyDetector.clearPressedKeys()
	return ret

func on_pressed_keys_updated():
	var pressedKeys = hotkeyDetector.pressedKeys()
	for key in pressedKeys:
		print("key pressed: " + key["name"] + ", code: " + str(key["key"]))
	if uiUpdateFunc != null:
		uiUpdateFunc.call_func(pressedKeys)

