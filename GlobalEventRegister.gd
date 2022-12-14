extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var notes = []
var recycler = null
var scroll_controller = null
var midi_parser = null
var data_manager = null

var hotkey_popups = null
var hotkey_events_connected = false

func register_hotkey_popups(h):
	hotkey_popups = h
	if scroll_controller != null and hotkey_events_connected == false:
		hotkey_popups.connect("hotkey_settings_opened", scroll_controller, "_on_hotkey_settings_opened")
		hotkey_popups.connect("hotkey_settings_closed", scroll_controller, "_on_hotkey_settings_closed")
		hotkey_events_connected = true

func register_data_manager(d):
	data_manager = d

func register_midi_parser(m):
	midi_parser = m

# Order matters -> nodes earlier in the scene are initialized first, so the midi_parser has to be earlier in the scene
func register_scroll_controller(s):
	scroll_controller = s
	midi_parser.connect("import_opened", scroll_controller, "_on_import_opened")
	midi_parser.connect("import_closed", scroll_controller, "_on_import_closed")
	data_manager.connect("playback_scroll", scroll_controller, "_on_playback_scroll")
	
	if hotkey_popups != null and hotkey_events_connected == false:
		hotkey_popups.connect("hotkey_settings_opened", scroll_controller, "_on_hotkey_settings_opened")
		hotkey_popups.connect("hotkey_settings_closed", scroll_controller, "_on_hotkey_settings_closed")
		hotkey_events_connected = true

func unregister_hotkey_popups():
	hotkey_popups = null

func unregister_scroll_controller():
	scroll_controller = null

func register_recycler(r):
	recycler = r
	midi_parser.connect("data_loaded", recycler, "_on_data_loaded")

func unregister_recycler():
	midi_parser.disconnect("data_loaded", recycler, "_on_data_loaded")
	recycler = null

func unregister_note(note):
	var found = notes.find(note)
	if found != -1:
		notes.remove(found)

func register_note(note):
	if notes.has(note):
		return
	
	notes.append(note)
	note.connect("note_activated", recycler, "_on_note_activated")
	data_manager.connect("playback_scroll", note, "_on_playback_time")
	data_manager.connect("playback_note", note, "_on_note_playback")
