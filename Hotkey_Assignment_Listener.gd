extends Node

var hotkeyDetector = null
var uiUpdateFunc = null
var gwidiHotkeyOptionsInstance = null

# TODO: Hook this up to UI!

# Called when the node enters the scene tree for the first time.
func _ready():
	hotkeyDetector = Gwidi_HotKey.new()
	gwidiHotkeyOptionsInstance = Gwidi_Options.new()

func start_listening(updateFunc):
	var f = funcref(self, "on_pressed_keys_updated")
	uiUpdateFunc = updateFunc
	hotkeyDetector.assignPressedKeyListener(f)
	hotkeyDetector.beginListening()

func stop_listening(hotkey_name, do_update):
	hotkeyDetector.stopListening()
	
	var ret = hotkeyDetector.pressedKeys()
	
	if do_update:
		var keys = Array()
		for key in ret:
			keys.append(key["key"])
		gwidiHotkeyOptionsInstance.assignHotkey(hotkey_name, keys)
	
	hotkeyDetector.clearPressedKeys()
	return ret

func on_pressed_keys_updated():
	var pressedKeys = hotkeyDetector.pressedKeys()
	for key in pressedKeys:
		print("key pressed: " + key["name"] + ", code: " + str(key["key"]))
	if uiUpdateFunc != null:
		uiUpdateFunc.call_func(pressedKeys)

