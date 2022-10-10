extends Node2D

const Octave = preload("res://Octave.tscn")

var is_visible = false
var data_pos = null

var measure_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	build_octaves()

func build_octaves():
	for i in range(Globals.num_octaves):
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
	return Globals.num_octaves * Globals.octave_height()

func bind_data(data):
	measure_num = data["measure"]
	$Title.text = str(measure_num)
	for octave_num in range($Octaves.get_child_count()):
		var octave = $Octaves.get_child(octave_num)
		var octave_data = {"measure": measure_num, "octave": octave_num, "data": data["data"][octave_num]}
		octave.bind_data(octave_data)

func _on_VisNotifier_screen_entered():
	is_visible = true

func _on_VisNotifier_screen_exited():
	is_visible = false

func is_visible_in_screen():
	return is_visible_in_tree() and is_visible

