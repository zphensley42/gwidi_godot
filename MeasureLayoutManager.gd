extends Node

signal scroll_measures

const NoteMeasure = preload("res://NoteMeasure.tscn")
const NoteOctave = preload("res://NoteOctave.tscn")
const NoteValue = preload("res://NoteValue.tscn")

export var measure_count = 1
export var octave_count = 3
export var note_count = 16
export var pitch_count = 8
export var scroll_mult = 10
export var preload_count = 4

var measure_data = []

func preload_measures():
	# TODO: Need a separation between the backing data for the view and the view
	# TODO: Generate the views in cached/active as-is, but describe a 'binding' method
	# TODO: To apply the data to the view
	# TODO: In this example, the data is a full measure
	for i in measure_count:
		measure_data.append(generate_new_measure(i))
	
	var dummy_measure = generate_new_measure(0)
	for i in range(preload_count):
		var node_measure = build_empty_node(dummy_measure, i)
		$HiddenMeasures.add_child(node_measure)

# TODO: Instead of spawning a ton of nodes and filling them all, possibly just do the following
# TODO: Allocate a set amount of nodes that can be pulled from and moved to a position on the screen
# TODO: When a new measure needs to be added because we determine a new position is to be displayed, we pull
# TODO: an existing measure, fill it with data, and put it at that position
# TODO: When a measure needs to be removed because that position is no longer displayed, we remove it from the
# TODO: displayed measures but leave it allocated in the manager, marking it avaialble for the next new
# TODO: displayed measure
# TODO: This could be facilitated by a system that uses 'root' nodes that determine when a measure needs to be
# TODO: displayed or not (these nodes are possibly just attachments at the beginning/end of a measure that are 
# TODO: not 'displayed' but are instanced and put in the same place still)

var scroll_offset_amount = Vector2(0, 0)

func measure_width():
	return Globals.block_width * note_count

func octave_height():
	return Globals.block_height * pitch_count

func measure_height():
	return octave_height() * octave_count

func generate_new_measure(num):
	var measure_number = num
	
	var octaves = []
	var measure = {"number": measure_number}
	for i in range(0, octave_count):
		var octave = {}
		var notes = []
		for j in range(0, note_count):
			for k in range(0, pitch_count):
				var note = {"time": j, "pitch": k}
				note["position"] = Vector2(
					j * Globals.block_width,
					k * Globals.block_height
				)
				notes.append(note)
		octave["notes"] = notes
		octave["position"] = Vector2(
			0,
			i * octave_height()
		)
		octaves.append(octave)
	measure["octaves"] = octaves
	measure["position"] = Vector2(
		measure_number * measure_width(),
		0
	)
	
	return measure

func clear_nodes():
	get_tree().call_group("notes", "queue_free")
	get_tree().call_group("octaves", "queue_free")
	get_tree().call_group("measures", "queue_free")

func bind_node(measure_node, measure_data):
	var measure_number = measure_data["number"]
	# TODO: Fill-out by applying data to attribs in the node (view)
	measure_node.init_position(Vector2(measure_number * measure_width(), 0) + (measure_number * Vector2(Globals.measure_title_width, 0)))

func build_empty_node(measure, number):
	var new_measure = NoteMeasure.instance()
	new_measure.hide()
	new_measure.measure_number = number
	new_measure.init_position(measure["position"] + (number * Vector2(Globals.measure_title_width, 0)))
	connect("scroll_measures", new_measure, "scroll_measures")
	
	for o in range(measure["octaves"].size()):
		var octave = measure["octaves"][o]
		var new_octave = NoteOctave.instance()
		new_octave.octave_value = o
		new_octave.init_position(octave["position"] + (o * Vector2(0, Globals.octave_title_height)))
		
		for n in range(octave["notes"].size()):
			var note = octave["notes"][n]
			var new_note = NoteValue.instance()
			new_note.note_time = note["time"]
			new_note.note_name = note["pitch"]
			new_note.init_position(note["position"])
			new_note.init_text(number, o, note["pitch"], note["time"])
			new_octave.get_node("ValuePanel").add_child(new_note)
		
		new_octave.resize_titles(measure_width(), octave_height())
		new_measure.get_node("OctavePanel").add_child(new_octave)
	
	new_measure.assign_marks(measure_width() + Globals.measure_title_width)
	new_measure.connect("next_measure", self, "on_next_measure")
	new_measure.connect("prev_measure", self, "on_prev_measure")
	new_measure.connect("remove_measure", self, "on_remove_measure")
	
	return new_measure

var is_dragging = false
var dragging_start = null
var dragging_current = null
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if not is_dragging:
				dragging_start = event.position
				dragging_current = event.position
			is_dragging = true
		elif not event.pressed and is_dragging and event.button_index == BUTTON_LEFT:
			is_dragging = false
	elif event is InputEventMouseMotion:
		if is_dragging:
			dragging_current = event.position
			var diff = dragging_start - dragging_current
			scroll_offset_amount -= diff
			emit_signal("scroll_measures", scroll_offset_amount)
			dragging_start = dragging_current

func _process(delta):
	var scroll_val = 0
	if Input.is_action_just_released("scroll_right"):
		scroll_val = -1
	elif Input.is_action_just_released("scroll_left"):
		scroll_val = 1
	
	if scroll_val != 0:
		scroll_offset_amount += Vector2(scroll_val * scroll_mult, 0)
		emit_signal("scroll_measures", scroll_offset_amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	preload_measures()
	var starting_measure = $HiddenMeasures.get_child(0)
	$HiddenMeasures.remove_child(starting_measure)
	$ActiveMeasures.add_child(starting_measure)
	starting_measure.show()


func on_next_measure(from_number):
	print("on_next_measure")
	var node = $HiddenMeasures.get_child(0)
	# node.state = "loading"
	bind_node(node, measure_data[from_number + 1])
	node.measure_number = from_number + 1
	$HiddenMeasures.remove_child(node)
	$ActiveMeasures.add_child(node)
	node.show()
			

func on_prev_measure(from_number):
	print("on_prev_measure")
	if from_number > 0:
		var node = $HiddenMeasures.get_child(0)
		# node.state = "loading"
		bind_node(node, measure_data[from_number - 1])
		node.measure_number = from_number - 1
		$HiddenMeasures.remove_child(node)
		$ActiveMeasures.add_child(node)
		node.show()

# In principle, this works -- but timing makes this wrong, look into this
func on_remove_measure(from_number):
	print("remove_measure")
	# find this number in the list, remove it
	for m in range($ActiveMeasures.get_child_count()):
		var node = $ActiveMeasures.get_child(m)
		if node.measure_number == from_number:
			$ActiveMeasures.remove_child(node)
			$HiddenMeasures.add_child(node)
			node.hide()
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
