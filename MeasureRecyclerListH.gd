extends Node

const ListNode = preload("res://MeasureListNode.tscn")

# TODO: Attempt to use this implementation of a list with nodes as the holder of measures
# TODO: Each measure is a node in the list, should help us re-use nodes for large datasets

var data_items = []
var view_items = {}
export var max_view_items = 4
var start_data_index = 0
var current_scroll_data_index = 0

var list_width = 0
var measured_node_width = 0

func measured_list_width():
	return measured_node_width * data_items.size()

var scroll_x = 0
var scroll_y = 0
func on_scroll(sx, sy):
	print("on_scroll(" + str(sx) + ", " + str(sy) + ")")
	$Nodes.position.x = sx
	scroll_x = sx
	$Nodes.position.y = sy
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
	
	for pos in range(first_visible_data_pos, last_visible_data_pos):
		if pos >= data_items.size() or pos < 0:
			break
		
		var view_pos = pos % view_items.size()
		var view_node = $Nodes.get_child(view_pos)
		# print("pos: " + str(pos) + ", view_pos: " + str(view_pos))
		
		# Only bind when the data position has changed for the view (before we re-assign the position)
		if view_node.data_pos != pos:
			view_node.bind_data(data_items[pos])
		
		view_node.init(Vector2(pos * view_node.node_width(), 0), pos)

# Design:
# Keep data items and view items separate
# Initialize up to X view items, when scrolling and a view items goes out of view, move this item to the other side of scrolling
## There are edge cases around the beginning/end of a dataset
# View items are instantiated based on retrieving a data item for that position


func assign_data(d):
	data_items = d
	build_nodes()

func build_nodes():
	view_items.clear()
	for c in $Nodes.get_children():
		$Nodes.remove_child(c)
		c.queue_free()
		
	var xpos = 0
	var item_range = min(max_view_items, data_items.size())
	for i in item_range:
		var node = ListNode.instance()
		node.init(Vector2(xpos, 0), i)
		$Nodes.add_child(node)
		view_items[i] = node
		xpos += node.node_width()
		
		bind_node(node, data_items[i])

func bind_node(n, d):
	n.bind_data(d)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var data = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5", "Test 6"]
	assign_data(data)
	
	list_width = $Background.margin_right
	
	var dummy = ListNode.instance()
	$ScrollController.init(dummy, $Background.margin_right, $Background.margin_bottom, data_items.size(), self)
	measured_node_width = dummy.node_width()
	dummy.queue_free()

