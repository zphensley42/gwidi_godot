extends Node2D

export var octave_value = 0

var initial_position = Vector2(0, 0)

func init_position(p):
	initial_position = p
	position = initial_position
	
func resize_titles(measure_width, octave_height):
	get_node("OctaveTitle/ColorRect").margin_right = measure_width + Globals.measure_title_width
	get_node("MeasureTitle/ColorRect").margin_bottom = octave_height + Globals.octave_title_height

# Called when the node enters the scene tree for the first time.
func _ready():
	$ValuePanel.position.y = Globals.octave_title_height

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
