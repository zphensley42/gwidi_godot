extends Node

var InputPopup = load("res://scenes/InputPopup.tscn")

var input_value = null
var root = null
var pop = null
var pop_edit = null

func register_parent(parent):
	root = parent
	pop = InputPopup.instance()
	pop_edit = pop.get_node("MarginContainer/VBoxContainer/PanelContainer/InputEdit")
	root.add_child(pop)
	
	var pop_okay = pop.get_node("MarginContainer/VBoxContainer/HBoxContainer/ButtonOkay")
	var pop_cancel = pop.get_node("MarginContainer/VBoxContainer/HBoxContainer/ButtonCancel")
	pop_okay.connect("pressed", self, "_on_popup_okay_pressed")
	pop_cancel.connect("pressed", self, "_on_popup_cancel_pressed")

func get_input(f):
	input_value = null
	
	pop.popup_centered()
	yield(pop, "popup_hide")
	if input_value == null:
		pop_edit.text = ""
	
	f.call_func(input_value)

func _on_popup_okay_pressed():
	input_value = pop_edit.text
	pop_edit.text = ""
	pop.hide()

func _on_popup_cancel_pressed():
	input_value = null
	pop_edit.text = ""
	pop.hide()

