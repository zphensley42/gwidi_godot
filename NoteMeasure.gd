extends Node2D

signal prev_measure
signal next_measure
signal remove_measure

var measure_number = 0

var initial_position = Vector2(0, 0)
var scroll_offset = Vector2(0, 0)

func scroll_measures(amount):
	scroll_offset = amount
	position = initial_position + scroll_offset

func init_position(p):
	initial_position = p
	position = initial_position

func assign_marks(measure_end):
	$BeginningMark.position.x = 0
	$EndingMark.position.x = measure_end
	$FullMark.position.x = 0
	$FullMark/FullVisibilityNotifier.rect.size.x = measure_end
	$FullMark/ColorRect.margin_right = measure_end

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var start_visible = false
var end_visible = false
var full_visible = false

func is_fully_visible():
	return is_visible_in_tree() and full_visible

func send_node_scroll_signal(type):
	if !full_visible || !is_visible_in_tree():
		return
	if type == "beg":
		emit_signal("prev_measure", measure_number)
	elif type == "end":
		emit_signal("next_measure", measure_number)

func _on_BeginningVisibilityNotifier_screen_entered():
	start_visible = true
	send_node_scroll_signal("beg")
	print("BEGINNING Measure: " + name + " entered the screen")


func _on_BeginningVisibilityNotifier_screen_exited():
	start_visible = false
	print("BEGINNING Measure: " + name + " exited the screen")


func _on_EndingVisibilityNotifier_screen_entered():
	end_visible = true
	send_node_scroll_signal("end")
	print("ENDING Measure: " + name + " entered the screen")


func _on_EndingVisibilityNotifier_screen_exited():
	end_visible = false
	print("ENDING Measure: " + name + " exited the screen")


func _on_FullVisibilityNotifier_screen_entered():
	if is_visible_in_tree():
		print("FULL VISIBILE entered screen: " + name)
		full_visible = true

func _on_FullVisibilityNotifier_screen_exited():
	if is_visible_in_tree():
		print("FULL VISIBILE exited screen: " + name)
		full_visible = false
		emit_signal("remove_measure", measure_number)

