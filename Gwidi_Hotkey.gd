extends Node

var hotkeyDetector = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_Load_pressed():
	if hotkeyDetector == null:
		hotkeyDetector = Gwidi_HotKey.new()
		hotkeyDetector.beginListening()
		hotkeyDetector.clearPressedKeys()
	else:
		var pressedKeys = hotkeyDetector.pressedKeys()
		for key in pressedKeys:
			print("key pressed: " + key["name"] + ", code: " + str(key["key"]))
		hotkeyDetector.clearPressedKeys()
