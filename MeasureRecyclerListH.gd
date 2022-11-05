extends Node

const ListNode = preload("res://scenes/MeasureListNode.tscn")

# TODO: Attempt to use this implementation of a list with nodes as the holder of measures
# TODO: Each measure is a node in the list, should help us re-use nodes for large datasets

# TODO: Need to resize to the viewport size when the viewport size changes

var data_items_measures = []

var view_items = {}
export var max_view_items = 4
var start_data_index = 0
var current_scroll_data_index = 0

var list_width = 0
var measured_node_width = 0

export var list_offset = Vector2(0, 0)

func measured_list_width():
	return measured_node_width * get_data_items().size()

var scroll_x = 0
var scroll_y = 0
func on_scroll(sx, sy):
	print("on_scroll(" + str(sx) + ", " + str(sy) + ")")
	$Canvas/Nodes.position.x = sx
	scroll_x = sx
	$Canvas/Nodes.position.y = sy
	scroll_y = sy
	
	check_recycle()

# Handling recycling
func check_recycle():
	var sx = -scroll_x
	current_scroll_data_index = sx / measured_node_width
	
	# for each view item, move its position according to the data position it is
	# determine the view position of a data item by converting the visible indexes per the amount of view nodes available
	# step 1 in this is to enumerate the indices
	# step 2 is to convert each data position to view position
	# step 3 is to move that view defined by the view position to the location of the new data item's positioning
	
	# Ceiling the last position to move us there sooner in the division, could possibly offset it to ensure we load before hitting the end of the previous item as well
	# But, for now, this will do
	var first_visible_data_pos = int(current_scroll_data_index)
	var last_visible_data_pos = int(ceil((sx + list_width) / measured_node_width))
	
	# print("first_visible_data_pos: " + str(first_visible_data_pos) + ", last_visible_data_pos: " + str(last_visible_data_pos))
	
	for pos in range(first_visible_data_pos, last_visible_data_pos + 1):	# +1 to ensure we always have one after the visual 'end'
		if pos >= data_items_measures.size() or pos < 0:
			break
		
		var view_pos = pos % view_items.size()
		var view_node = $Canvas/Nodes.get_child(view_pos)
		# print("pos: " + str(pos) + ", view_pos: " + str(view_pos))
		
		# Only bind when the data position has changed for the view (before we re-assign the position)
		if view_node.data_pos != pos:
			view_node.bind_data(data_item_for_position(pos))
		
		view_node.init(Vector2(pos * view_node.node_width(), 0), pos)

# Design:
# Keep data items and view items separate
# Initialize up to X view items, when scrolling and a view items goes out of view, move this item to the other side of scrolling
## There are edge cases around the beginning/end of a dataset
# View items are instantiated based on retrieving a data item for that position


func refresh_data():
	Globals.calc_size_constants(get_data_items())
	data_items_measures = get_data_items().getMeasures()
	build_nodes()
	init_scroll_controller()

func build_nodes():
	view_items.clear()
	for c in $Canvas/Nodes.get_children():
		$Canvas/Nodes.remove_child(c)
		c.queue_free()
		
	var xpos = 0
	var measure_count = data_items_measures.size()
	var item_range = min(max_view_items, measure_count)
	for i in item_range:
		var node = ListNode.instance()
		node.init(Vector2(xpos, 0), i)
		$Canvas/Nodes.add_child(node)
		view_items[i] = node
		xpos += node.node_width()
		
		bind_node(node, data_item_for_position(i))

func bind_node(n, d):
	n.bind_data(d)

func init_scroll_controller():
	$Canvas/Background.update()
	list_width = $Canvas/Background.rect_size.x
	var list_height = $Canvas/Background.rect_size.y
	
	var dummy = ListNode.instance()
	var data_size = data_items_measures.size()
	$ScrollController.init(dummy, list_offset, list_width, list_height, data_size, self)
	measured_node_width = dummy.node_width()
	dummy.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	# TODO: Instead of active resize, have a setting to move to full-screen or other resolutions
	# TODO: with this setting, explicitly resize things on setting change
	OS.min_window_size = Vector2(1024, 600)
	# get_tree().get_root().connect("size_changed", self, "init_scroll_controller")
	
	var eventRegister = get_node("/root/GlobalEventRegister")
	eventRegister.register_recycler(self)
	
	$Canvas/Nodes.position = list_offset
	$Canvas/Background.margin_left = list_offset[0]
	$Canvas/Background.margin_top = list_offset[1]
	
	var d = build_test_data()
	GwidiDataManager.assign_data(d)
	refresh_data()
	
	init_scroll_controller()

func _on_note_activated(note):
	get_data_items().toggleNote(note)
	
func _on_data_loaded(d):
	refresh_data()

func data_item_for_position(pos):
	return data_items_measures[pos]

# TODO: Actually build this data from a couple of places:
# TODO: 1 - default, no actual data but instead use a set of params like
# TODO:   - # of measures, instrument config, etc
# TODO: 2 - parsed midi import data and instrument config
# TODO: 3 - loaded gwidi data and instrument config

func test_native_data():
	var gwidi_data = Gwidi_Gui_Data.new()
	gwidi_data.addMeasure()
	var measureCount = gwidi_data.getMeasures().size()
	
	# Grabbing the measure (creating the new obj) is crashing us when it tries to destruct
	# When the reference is lost in GD, the native obj is destructed
	var measure = gwidi_data.getMeasures()[0]
	var octaves = measure.getOctaves()
	var times = octaves[0].getTimes()
	var notesForTime0 = times[0]
	var note1 = notesForTime0[0]
	var note1Letters = note1.getLetters()
	
	print("tested!")
	
func get_data_items():
	return GwidiDataManager.get_assigned_data()
	
func build_test_data():

	test_native_data()
	var gwidi_data = Gwidi_Gui_Data.new()
	return gwidi_data

func addMeasure():
	# TODO: Profile this, but I'm pretty sure refresh_data() just takes too long
	# TODO: If we can't address that, add a spinner?
	get_data_items().addMeasure()
	refresh_data()
