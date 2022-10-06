extends Node

var data_count = 0
var list_width = 0
var list_height = 0
var measured_node_width = 0
var measured_node_height = 0
var scroll_callback = null

func measured_list_width():
	return measured_node_width * data_count

func measured_list_height():
	return measured_node_height

func init(dummy_node, lw, lh, dc, scroll_cb):
	list_width = lw
	list_height = lh
	data_count = dc
	
	measured_node_width = dummy_node.node_width()
	measured_node_height = dummy_node.node_height()
	
	scroll_callback = scroll_cb


# HANDLE SCROLLING AMOUNT
var scroll_mult = 10
var scroll_x = 0
var scroll_y = 0
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
			scroll_y -= diff.y
			scroll_x -= diff.x
			dragging_start = dragging_current
			update_scroll()

func _process(delta):
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
	if scroll_x >= 0:
		scroll_x = 0
	elif scroll_x <= lw:
		scroll_x = lw
	
	var lh = -(measured_list_height() - list_height)
	# Clamp our scroll to start/end of the list
	if scroll_y >= 0:
		scroll_y = 0
	elif scroll_y <= lh:
		scroll_y = lh
		
	# $Nodes.position.x = scroll_x
	
	if scroll_callback != null:
		print("scb  measured_list_width: " + str(measured_list_width()) + ", measured_list_height: " + str(measured_list_height()) + ", list_width: " + str(list_width) + ", list_height: " + str(list_height) + ", data_count: " + str(data_count))
		scroll_callback.on_scroll(scroll_x, scroll_y)
# END HANDLE SCROLLING AMOUNT




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass