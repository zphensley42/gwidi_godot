extends Node2D

export var note_time = 0
export var note_name = 0

var initial_position = Vector2(0, 0)

func init_position(p):
	initial_position = p
	position = initial_position

func init_text(measure, octave, pitch, time):
	$MeasureLabel.text = str(measure)
	$OctaveLabel.text = str(octave)
	$NoteLabelPitch.text = str(pitch)
	$NoteLabelTime.text = str(time)

# Called when the node enters the scene tree for the first time.
func _ready():
	$NoteRect.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NoteRect_mouse_entered():
	$NoteRect.color = Color(0, 255, 255, 255)


func _on_NoteRect_mouse_exited():
	$NoteRect.color = Color("e6d6d6")
