extends Control

# 0 == nothing, 1 == hover, 2 == selected, 3 == selected and hovered
var drawState = 0
var isSelected = false
var isHovered = false

var style = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.add_stylebox_override("panel", style)

func update_draw_state():
	drawState = int(isHovered) + (2 * int(isSelected))
	
	if drawState == 1:
		style.set_bg_color(Color("6eaaa9"))
	elif drawState == 2:
		style.set_bg_color(Color("2452c1"))
	elif drawState == 3:
		style.set_bg_color(Color("3060d2"))
	else:
		style.set_bg_color(Color("999999"))


func bind(title):
	$Panel/GridContainer/HotkeyName.text = title

func _on_GridContainer_mouse_entered():
	isHovered = true
	update_draw_state()

func _on_GridContainer_mouse_exited():
	isHovered = false
	update_draw_state()

func _on_GridContainer_gui_input(event):
	# detect mouse clicks for selection
	if not isHovered:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			isSelected = !isSelected
			event.pressed = false
			
			update_draw_state()
