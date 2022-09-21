extends Node2D

var pitch = 0
var time = 0


func init(p, t):
	pitch = p
	time = t
	
	position = Vector2(Globals.note_width * time, Globals.note_height * pitch)
	$TitleBackground.margin_right = Globals.note_width
	$TitleBackground.margin_bottom = Globals.note_height
	$Title.margin_right = Globals.note_width
	$Title.margin_bottom = Globals.note_height
	
	$Title.text = str(pitch) + " " + str(time)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
