extends Node


var native_listener = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("HotkeyListener ready called")
	native_listener = Gwidi_HotKey.new()
	start()
	
func start():
	native_listener.beginListening()

func stop():
	native_listener.stopListening()

func assign_hotkey(hotkeyName, f):
	native_listener.assignHotkeyFunction(hotkeyName, f)
