extends Node

var scrolling_enabled = true

var data_count = 0
var list_offset = 0
var list_width = 0
var list_height = 0
var measured_node_width = 0
var measured_node_height = 0
var scroll_callback = null


var scroll_mult = 10
var scroll_x = 0
var scroll_y = 0
var scroll_y_enabled = true

func measured_list_width():
	return measured_node_width * data_count

func measured_list_height():
	return measured_node_height

# TODO: There is still something funky with this as we resize the window
func init(dummy_node, lo, lw, lh, dc, scroll_cb):
	list_offset = lo
	list_width = lw
	list_height = lh
	data_count = dc
	
	scroll_x = list_offset[0]
	scroll_y = list_offset[1]
	
	measured_node_width = dummy_node.node_width()
	measured_node_height = dummy_node.node_height()
	scroll_y_enabled = measured_node_height > list_height # don't allow y scrolling if we don't need it
	
	scroll_callback = scroll_cb
	
	print("scroll controller init:{")
	print("\tlist_offset: " + str(list_offset))
	print("\tlist_width: " + str(list_width))
	print("\tlist_height: " + str(list_height))
	print("\tdata_count: " + str(data_count))
	print("\tscroll_x: " + str(scroll_x))
	print("\tscroll_y: " + str(scroll_y))
	print("\tmeasured_node_width: " + str(measured_node_width))
	print("\tmeasured_node_height: " + str(measured_node_height))
	print("}")


# HANDLE SCROLLING AMOUNT
# TODO: Don't allow mouse button scrolling if we aren't hovering over our nodes when we start the action
var is_dragging = false
var dragging_start = null
var dragging_current = null
func _input(event):
	if not scrolling_enabled:
		return
		
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
			if scroll_y_enabled:
				scroll_y -= diff.y
			scroll_x -= diff.x
			dragging_start = dragging_current
			update_scroll()

func _process(_delta):
	if not scrolling_enabled:
		return
		
	if Input.is_action_pressed("scroll_shift"):
		var scroll_x_val = 0
		if Input.is_action_just_released("scroll_right"):
			scroll_x_val = -1
		elif Input.is_action_just_released("scroll_left"):
			scroll_x_val = 1
		
		if scroll_x_val != 0:
			scroll_x += scroll_x_val * scroll_mult
			update_scroll()
	else:
		if !scroll_y_enabled:
			return
		var scroll_y_val = 0
		if Input.is_action_just_released("scroll_right"):
			scroll_y_val = -1
		elif Input.is_action_just_released("scroll_left"):
			scroll_y_val = 1
		
		if scroll_y_val != 0:
			scroll_y += scroll_y_val * scroll_mult
			update_scroll()

func update_scroll():
	var lw = -(measured_list_width() - list_width)
	# Clamp our scroll to start/end of the list
	if scroll_x >= list_offset[0]:
		scroll_x = list_offset[0]
	elif scroll_x <= lw:
		scroll_x = lw
	
	var mlh = measured_list_height() # measured list height == total size of the data to show
	var lh = -(mlh - list_height)  # list height == size of the list background on the screen
	# Clamp our scroll to start/end of the list
	if scroll_y >= list_offset[1]:
		scroll_y = list_offset[1]
	elif scroll_y <= lh:
		scroll_y = lh 
		
	# $Nodes.position.x = scroll_x
	
	if scroll_callback != null:
		print("scb  measured_list_width: " + str(measured_list_width()) + ", measured_list_height: " + str(measured_list_height()) + ", list_width: " + str(list_width) + ", list_height: " + str(list_height) + ", data_count: " + str(data_count))
		scroll_callback.on_scroll(scroll_x, scroll_y)
# END HANDLE SCROLLING AMOUNT


func _on_import_opened():
	print("_on_import_opened")
	scrolling_enabled = false

func _on_import_closed():
	print("_on_import_closed")
	scrolling_enabled = true

func _on_playback_scroll(indexedTimeOffset, indexedTime):
	# indexedTime can be used to help display which notes are playing (probably not from scroll controller though)
	scroll_x = -indexedTimeOffset
	update_scroll()


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/GlobalEventRegister".register_scroll_controller(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
