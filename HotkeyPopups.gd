extends Control

var selected_item = null

func show_popup():
	$SettingsDialog.popup_centered()

func show_enter_keys():
	$KeyInputDialog.popup_centered()
	var f = funcref(self, "update_pressed_keys_ui")
	$Hotkey_Assignment_Listener.start_listening(f)
	# Start listening for keys

# Called when the node enters the scene tree for the first time.
func _ready():
	show_popup()
	
	# TODO: Fill the hotkey values from ones already stored in the hotkey config
	# TODO: Updating already works, just need to show the initial values
	# TODO: When loading hotkeys, need to assign the functions
	
	var items_container = $SettingsDialog/MarginContainer/ScrollContainer/VBoxContainer
	for child in items_container.get_children():
		if child.name == "ColumnTitles":
			continue
		
		var button = child.get_node("HBoxContainer/Button")
		button.connect("pressed", self, "_on_item_setkeys_pressed", [child])
	
	var ok_but = $KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/Buttons/OK
	ok_but.connect("pressed", self, "_on_inputdialog_ok")
	
	var cancel_but = $KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/Buttons/Cancel
	cancel_but.connect("pressed", self, "_on_inputdialog_cancel")

func _on_inputdialog_ok():
	$KeyInputDialog.hide()
	var item_name = selected_item.hotkey_name
	var keys = $Hotkey_Assignment_Listener.stop_listening(item_name, true)
	selected_item.get_node("HBoxContainer/KeyList").text = build_key_str(keys)
	selected_item = null
	$KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/InputKeys.text = ""
	

func _on_inputdialog_cancel():
	$KeyInputDialog.hide()
	$Hotkey_Assignment_Listener.stop_listening("", false)
	selected_item = null
	$KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/InputKeys.text = ""

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
	$KeyInputDialog/MarginContainer/PanelContainer/VBoxContainer/InputKeys.text = keysStr
