extends Node

const HotkeySettings = preload("res://scenes/HotkeySettings.tscn")

const but_play = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Play")
const but_stop = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Stop")
const but_clear = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Clear")
const but_load = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Load")
const but_import = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Import")
const but_save = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Save")
const but_settings = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Settings")
const but_add_measure = NodePath("/root/Main2/UiCanvasLayer/HBoxContainer/Button_Add_Measure")
const hotkey_popups = NodePath("/root/Main2/UiCanvasLayer/HotkeyPopups")
const recycler_list = NodePath("/root/Main2/MeasureRecyclerListH")

# Called when the node enters the scene tree for the first time.
func _ready():
	GwidiDataManager.connect("playback_ended", self, "_on_playback_ended")
	
	var hotkey_popups_node = get_node(hotkey_popups)
	hotkey_popups_node.register_playback_controller(self)
	
	# TODO: Need to connect signals to each hotkey function
	# connect("Hotkey_Activated", hotkey_popups_node, "_on_hotkey_activated")	

func _on_hotkey_activated(hotkey):
	print("Playback: _on_hotkey_activated(" + hotkey + ")")
	if(hotkey == "PlayPause"):
		_on_Button_Play_pressed()
	elif(hotkey == "Stop"):
		_on_Button_Stop_pressed()

# 0 = stopped, 1 = play, 2 == pause
var play_state = 0
func _pause_shortcut():
	GwidiDataManager.playback_pause()
	play_state = 2
	
	update_play_button()
	
func _on_Button_Play_pressed():
	# TODO: When playing, make sure that our GUI data is reflected in the GwidiDataManager for playback
	if play_state == 0 or play_state == 2:
		play_state = 1
		GwidiDataManager.playback_play()
	elif play_state == 1:
		GwidiDataManager.playback_pause()
		play_state = 2
	
	update_play_button()

func update_play_button():
	if play_state == 1:
		get_node(but_play).text = "Pause"
	elif play_state == 0 or play_state == 2:
		get_node(but_play).text = "Play"
	
	get_node(but_add_measure).disabled = (play_state == 1)


func _on_Button_Stop_pressed():
	GwidiDataManager.playback_stop()

func _on_playback_ended():
	play_state = 0
	update_play_button()


func _on_Button_Clear_pressed():
	# var fresh_data = Gwidi_Gui_Data.new()
	# TODO: Need a better method of managing the assignment of data across here, loading, and importing
	# TODO: They all need the data manager to react as well as the list to update
	# TODO: Need to ensure that all playback and such stops when import / load / clear is attempted
	#GwidiDataManager.assign_data(fresh_data)
	#emit_signal("data_loaded", fresh_data)
	pass


func _on_Button_Add_Measure_pressed():
	# TODO: Probably disable this if we are playing (it does work, but there are some thread locking concerns)
	if play_state != 1:
		var n = get_node(recycler_list)
		n.addMeasure()


func _on_Button_Settings_pressed():
	var n = get_node(hotkey_popups)
	n.show_popup()
