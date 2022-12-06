extends Node

signal GlobalWindowFocusChanged

var native_client = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	native_client = Gwidi_ServerClient.new()
	var ref = funcref(self, "on_focus_change")
	native_client.assignFocusChangeCallback("GDScript_GwidiServerClient", ref)
	
	start()

func start():
	native_client.start()

func stop():
	native_client.stop()

func on_focus_change(windowName, hasFocus):
	print("windowName: " + windowName + ", hasFocus: " + str(hasFocus))
	emit_signal("GlobalWindowFocusChanged", windowName, hasFocus)

