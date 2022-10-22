extends Node2D

const Octave = preload("res://Octave.tscn")

var is_visible = false
var data_pos = null

var measure_num = 0

# for now, only allow views to be built once when we first get our data
var view_initialized = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func build_octaves(data):
	if view_initialized:
		return
	
	view_initialized = true
	
	# Build our octaves based on the data
	var octaves = data.getOctaves()
	for o in data.getOctaves():
		var octave = Octave.instance()
		$Octaves.add_child(octave)
		octave.init()

func init(p, dp):
	if data_pos != null and data_pos == dp:
		return
	data_pos = dp
	position = p
	$TitleBackground.margin_right = Globals.measure_title_width
	$TitleBackground.margin_bottom = node_height() + (Globals.octave_title_height * Globals.num_octaves)
	
	$Title.margin_right = Globals.measure_title_width
	$Title.margin_bottom = node_height() + (Globals.octave_title_height * Globals.num_octaves)
	
	$VisNotifier.rect.size.x = node_width()
	$VisNotifier.rect.size.y = node_height()
	
	$Octaves.position = Vector2(Globals.measure_title_width, 0)

func node_width():
	return Globals.measure_width() + Globals.measure_title_width

func node_height():
	var h = 0
	for i in range(Globals.num_octaves):
		h += Globals.octave_height(i)
	return h

func bind_data(data):
	measure_num = data.num()
	$Title.text = str(measure_num)
	
	build_octaves(data)
	
	var octaves_data = data.getOctaves()
	for octave_num in range($Octaves.get_child_count()):
		var octave = $Octaves.get_child(octave_num)
		var octave_data = octaves_data[octave_num]
		octave.bind_data(octave_data)

func _on_VisNotifier_screen_entered():
	is_visible = true

func _on_VisNotifier_screen_exited():
	is_visible = false

func is_visible_in_screen():
	return is_visible_in_tree() and is_visible

