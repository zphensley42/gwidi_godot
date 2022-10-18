extends Node

signal import_opened
signal import_closed

export var metaMap = []


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/GlobalEventRegister".register_midi_parser(self)

func getTrackMeta(filename):
	var parser = Gwidi_Midi_Parser.new()
	metaMap = parser.getTrackMetaMap(filename)
	print("parsed meta!")



func _on_Button_Import_pressed():
	emit_signal("import_opened")
	$ImportCanvasLayer/MidiImportDialog.show()


func _on_MidiImportDialog_file_selected(path):
	print("selected file: " + path)
	getTrackMeta(path)


func _on_MidiImportDialog_hide():
	emit_signal("import_closed")

