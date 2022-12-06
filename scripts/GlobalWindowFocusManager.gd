extends Node

export(NodePath) var focusStatusLabel
export(NodePath) var focusStatusLabelContainer
export(NodePath) var focusStatusBG

const color_focused = Color("2ae236")
const color_unfocused = Color("ff5855")

const playback = NodePath("/root/Main2/Gwidi_Playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_focus_status(false)
	GwidiServerClient.connect("GlobalWindowFocusChanged", self, "_onGlobalWindowFocusChanged")

func _onGlobalWindowFocusChanged(windowName, hasFocus):
	print("_onGlobalWindowFocusChanged: " + windowName + ", " + str(hasFocus))
	update_focus_status(hasFocus)

func update_focus_status(focused):
	get_node(focusStatusBG).color = (color_focused if focused else color_unfocused)
	get_node(focusStatusLabel).text = ("Window Focused" if focused else "Window Not Focused")
	
	if not focused:
		get_node(playback)._pause_shortcut()
