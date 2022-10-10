extends Node2D

const Note = preload("res://Note.tscn")

var measure_num = 0
var octave_num = 0

func bind_data(data):
	# clear old notes first
	for n in $Notes.get_children():
		$Notes.remove_child(n)
		n.queue_free()
	
	measure_num = data["measure"]
	octave_num = data["octave"]
	var octave_data = data["data"]
	
	for note_time in octave_data.size():
		var note_time_map = octave_data[note_time]
		for note_letter in note_time_map.keys():
			var note_activated = note_time_map[note_letter]
			var note = Note.instance()
			$Notes.add_child(note)
			note.init()
			note.bind_data(measure_num, octave_num, note_time, note_letter, note_activated)
	
	bind_position()

func bind_position():
	position = Vector2(0, (octave_num * Globals.octave_height()) + (octave_num * Globals.octave_title_height))
	$Notes.position = Vector2(0, Globals.octave_title_height)

func build_notes():
	for i in range(Globals.num_pitches):
		for j in range(Globals.num_times):
			var note = Note.instance()
			$Notes.add_child(note)
			note.init()

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
