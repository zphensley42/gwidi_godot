extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var notes = []
var recycler = null

func register_recycler(r):
	recycler = r

func register_note(note):
	if notes.has(note):
		return
	
	notes.append(note)
	note.connect("note_activated", recycler, "_on_note_activated")
