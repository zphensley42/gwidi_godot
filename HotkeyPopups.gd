extends Control

signal hotkey_settings_opened
signal hotkey_settings_closed

var selected_item = null
var gwidi_hotkey_options = null

# TODO: When detecting hotkeys and/or playing back inputs
# TODO: try to determine if our focused window has moved away from the expected
# TODO: focus -- pause playback if that happens
# TODO: and ignore hotkey detection if that happens

var playback_controller = null
var known_hotkey_functions = {}
func register_playback_controller(p):
	playback_controller = p

func setup():
	known_hotkey_functions["play_pause"] = funcref(playback_controller, "_on_Button_Play_pressed")
	known_hotkey_functions["stop"] = funcref(playback_controller, "_on_Button_Stop_pressed")
	
	gwidi_hotkey_options = Gwidi_Options.new()
	var hotkey_config = gwidi_hotkey_options.hotkeyMapping()
	
	for hotkeyName in hotkey_config:
		get_node("Hotkey_Listener").assign_hotkey(hotkeyName, known_hotkey_functions[hotkeyName])
	
	var items_container = get_node("SettingsDialog/MarginContainer/ScrollContainer/VBoxContainer")
	for child in items_container.get_children():
		if child.name == "ColumnTitles":
			continue
		
		fill_item_from_config(child, hotkey_config)
		
		var button = child.get_node("HBoxContainer/Button")
		button.connect("pressed", self, "_on_item_setkeys_pressed", [child])
	
	var ok_but = get_node("KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/Buttons/OK")
	ok_but.connect("pressed", self, "_on_inputdialog_ok")
	
	var cancel_but = get_node("KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/Buttons/Cancel")
	cancel_but.connect("pressed", self, "_on_inputdialog_cancel")

func show_popup():
	# disable scrolling the notes while open
	emit_signal("hotkey_settings_opened")
	get_node("Hotkey_Listener").stop_listening()
	get_node("SettingsDialog").popup_centered()

func show_enter_keys():
	get_node("KeyInputDialog").popup_centered()
	var f = funcref(self, "update_pressed_keys_ui")
	get_node("Hotkey_Assignment_Listener").start_listening(f)
	# Start listening for keys

func fill_item_from_config(item, hotkey_config):
	var key_list = item.get_node("HBoxContainer/KeyList")
	var key_fn = item.get_node("HBoxContainer/HotkeyFunction")
	var keys = hotkey_config[item.hotkey_name]
	var keys_str = build_key_str(keys)
	
	key_list.text = keys_str
	get_node("Hotkey_Assignment_Listener").assign_hotkey(item.hotkey_name, key_fn)

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	GlobalEventRegister.register_hotkey_popups(self)

func _on_inputdialog_ok():
	get_node("KeyInputDialog").hide()
	var item_name = selected_item.hotkey_name
	var keys = get_node("Hotkey_Assignment_Listener").stop_listening(item_name, true)
	selected_item.get_node("HBoxContainer/KeyList").text = build_key_str(keys)
	selected_item = null
	get_node("KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/InputKeys").text = ""


func _on_inputdialog_cancel():
	get_node("KeyInputDialog").hide()
	get_node("Hotkey_Assignment_Listener").stop_listening("", false)
	selected_item = null
	get_node("KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/InputKeys").text = ""

func _on_item_setkeys_pressed(item):
	selected_item = item
	show_enter_keys()

func build_key_str(pressedKeys):
	if pressedKeys == null:
		return ""
	
	var keysStr = ""
	for entry in pressedKeys:
		if keysStr != "":
			keysStr += " + "
		keysStr += entry["name"]
	
	return keysStr

func update_pressed_keys_ui(pressedKeys):
	var keysStr = build_key_str(pressedKeys)
	get_node("KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/InputKeys").text = keysStr


var last_visible = false
func _on_SettingsDialog_visibility_changed():
	var new_visible = get_node("SettingsDialog").visible
	if last_visible != new_visible and new_visible == false:
		get_node("Hotkey_Listener").start_listening()
		emit_signal("hotkey_settings_closed")
	
	last_visible = new_visible
