extends Node2D

const Note = preload("res://Note.tscn")

var measure_num = 0
var octave_num = 0


func bind_data(data):
	$Title.text = "Octave " + str(data.num())
	# clear old notes first
	for n in $Notes.get_children():
		$Notes.remove_child(n)
		n.queue_free()
	
	measure_num = data.measure()
	octave_num = data.num()
	
	var note_times = data.getTimes()
	for time in note_times:
		var notes = note_times[time]
		for n in notes:
			var note = Note.instance()
			$Notes.add_child(note)
			note.init()
			note.bind_data(n)
			# note.bind_data(n.measure(), n.octave(), n.time(), n.getLetters()[0], n.key(), n.activated())
	
	bind_position()

func bind_position():
	# TODO: Read the '2' here from the options for this data (i.e. number of octaves for the instrument currently used)
	var reverse_y = 2 - octave_num
	position = Vector2(0, (reverse_y * Globals.octave_height()) + (reverse_y * Globals.octave_title_height))
	$Notes.position = Vector2(0, Globals.octave_title_height)

func init():
	bind_position()
	
	$TitleBackground.margin_bottom = Globals.octave_title_height
	$Title.margin_bottom = Globals.octave_title_height
	
	$TitleBackground.margin_right = Globals.measure_width()
	$Title.margin_right = Globals.measure_width()
	
	# build_notes()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
