extends Node

signal import_opened
signal import_closed
signal data_loaded

export var metaMap = []


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/GlobalEventRegister".register_midi_parser(self)

func getTrackMeta(filename):
	var parser = Gwidi_Midi_Parser.new()
	metaMap = parser.getTrackMetaMap(filename)
	print("parsed meta!")

func getMidiData(filename, track_num):
	var parser = Gwidi_Midi_Parser.new()
	return parser.importMidi(filename, track_num)


func _on_Button_Import_pressed():
	emit_signal("import_opened")
	$ImportCanvasLayer/MidiImportDialog.show()


func _on_MidiImportDialog_file_selected(path):
	print("selected file: " + path)
	var trackMeta = getTrackMeta(path)
	# TODO: Display the meta so that users can pick a track number
	var midiData = getMidiData(path, 1)
	print('midi data imported!')
	
	GwidiDataManager.assign_data(midiData)
	emit_signal("data_loaded", midiData)


func _on_MidiImportDialog_hide():
	emit_signal("import_closed")

