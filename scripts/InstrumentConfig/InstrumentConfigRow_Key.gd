extends HBoxContainer

var hover_style = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	hover_style.set_bg_color(no_hover_color)
	hover_style.set_corner_radius_all(2)
	get_node("letters_panel").add_stylebox_override("panel", hover_style)

func do_letters_input(value):
	if value == null:
		return
	
	# split on "," to get each letter for the list
	var list = get_node("letters_panel/letters_list")
	for c in list.get_children():
		list.remove_child(c)
		c.queue_free()
	
	var letters = value.split(",")
	for l in letters:
		var label = Label.new()
		label.text = l
		list.add_child(label)

func letters_input():
	var cb = funcref(self, "do_letters_input")
	InputRetrieval.get_input(cb)

func _on_letters_panel_gui_input(event):
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT:
			letters_input()


var hover_color = Color("6a6a6a")
var no_hover_color = Color("535353")
func _on_letters_list_mouse_entered():
	hover_style.set_bg_color(hover_color)
	get_node("letters_panel").update()


func _on_letters_panel_mouse_exited():
	hover_style.set_bg_color(no_hover_color)
	get_node("letters_panel").update()
