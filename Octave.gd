extends Node2D

const Note = preload("res://Note.tscn")

var octave_num = 0

func init(n):
	octave_num = n
	position = Vector2(0, (octave_num * Globals.octave_height()) + (octave_num * Globals.octave_title_height))
	$Notes.position = Vector2(0, Globals.octave_title_height)
	
	$TitleBackground.margin_bottom = Globals.octave_title_height
	$Title.margin_bottom = Globals.octave_title_height
	
	$TitleBackground.margin_right = Globals.measure_width()
	$Title.margin_right = Globals.measure_width()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(Globals.num_pitches):
		for j in range(Globals.num_times):
			var note = Note.instance()
			$Notes.add_child(note)
			note.init(i, j)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
