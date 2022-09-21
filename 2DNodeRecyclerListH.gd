extends Node

const ListNode = preload("res://ListNode.tscn")

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

# HANDLE SCROLLING AMOUNT
var scroll_mult = 10
var scroll_x = 0
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
			scroll_x -= diff.x
			dragging_start = dragging_current
			update_scroll()

func _process(delta):
	var scroll_val = 0
	if Input.is_action_just_released("scroll_right"):
		scroll_val = -1
	elif Input.is_action_just_released("scroll_left"):
		scroll_val = 1
	
	if scroll_val != 0:
		scroll_x += scroll_val * scroll_mult
		update_scroll()

func update_scroll():
	var lw = -measured_list_width()
	# Clamp our scroll to start/end of the list
	if scroll_x >= 0:
		scroll_x = 0
	elif scroll_x <= lw:
		scroll_x = lw
	$Nodes.position.x = scroll_x
	
	check_recycle()
# END HANDLE SCROLLING AMOUNT


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
	var dummy = ListNode.instance()
	measured_node_width = dummy.node_width()
	dummy.queue_free()
	
	list_width = $Background.margin_right
	
	var data = ["Test 1", "Test 2", "Test 3", "Test 4", "Test 5", "Test 6"]
	assign_data(data)

