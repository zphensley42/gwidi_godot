extends Node

var hotkeyDetector = null
var uiUpdateFunc = null
var gwidiHotkeyOptionsInstance = null

# TODO: Move this to a global-loaded class to listen across all scenes
var global_hotkey_detector = null

# Called when the node enters the scene tree for the first time.
func _ready():
	hotkeyDetector = Gwidi_HotKeyAssignmentPressDetector.new()
	gwidiHotkeyOptionsInstance = Gwidi_Options.new()
	global_hotkey_detector = Gwidi_HotKey.new()
	global_hotkey_detector.beginListening()

func start_listening(updateFunc):
	var f = funcref(self, "on_pressed_keys_updated")
	uiUpdateFunc = updateFunc
	hotkeyDetector.assignPressedKeyListener(f)
	hotkeyDetector.beginListening()
	
	# stop our global when getting keys to assign
	global_hotkey_detector.stopListening()

func stop_listening(hotkey_name, do_update):
	hotkeyDetector.stopListening()
	
	# resume our global after finished assigning
	global_hotkey_detector.beginListening()
	
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

func assign_hotkey(name, fn):
	var f = funcref(fn, "activate")
	global_hotkey_detector.assignHotkeyFunction(name, f)
