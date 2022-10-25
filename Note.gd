extends Node2D

signal note_activated

var measure = 0
var pitch = 0
var time = 0
var octave = 0
var letter = ""

var activated = false
var hovered = false
var played = false
var played_time = false

var note_data = null

# This should come from instrument config I guess
# TODO: An issue with how we draw GUI is that these are displayed in the opposite order
# TODO: quick-fix is to map them in opposite order here
var keys = {
	"1": 7,
	"2": 6,
	"3": 5,
	"4": 4,
	"5": 3,
	"6": 2,
	"7": 1,
	"8": 0
}

func bind_data(n, index):
	note_data = n
	measure = n.measure()
	octave = n.octave()
	#pitch = keys[n.key()]
	pitch = index
	letter = n.getLetters()[0]
	time = n.time()
	activated = n.activated()
	
	$Title.text = str(pitch) + " " + str(time) + " " + letter
	change_draw_state()
	
	bind_position()

func bind_position():
	# TODO: Fix this -- we have gaps in our display now because of mismatched # of pitches in our octaves
	position = Vector2(Globals.note_width * time, Globals.note_height * pitch)

func init():
	bind_position()
	$TitleBackground.margin_right = Globals.note_width - 1
	$TitleBackground.margin_bottom = Globals.note_height - 1
	$Stroke.margin_right = Globals.note_width
	$Stroke.margin_bottom = Globals.note_height
	$Title.margin_right = Globals.note_width
	$Title.margin_bottom = Globals.note_height
	
	$Title.text = str(pitch) + " " + str(time) + " " + letter

# Called when the node enters the scene tree for the first time.
func _ready():
	var eventRegister = get_node("/root/GlobalEventRegister")
	eventRegister.register_note(self)

func _exit_tree():
	var eventRegister = get_node("/root/GlobalEventRegister")
	eventRegister.unregister_note(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TitleBackground_mouse_entered():
	hovered = true
	change_draw_state()


func _on_TitleBackground_mouse_exited():
	hovered = false
	change_draw_state()

func change_draw_state():
	if played:
		$TitleBackground.color = Color.blue
	elif hovered and activated:
		$TitleBackground.color = Color("f45712")
	elif hovered:
		$TitleBackground.color = Color.darkturquoise
	elif activated:
		$TitleBackground.color = Color.chocolate
	else:
		$TitleBackground.color = Color("b7bed2")

# TODO: Probably need a separate controller keeping track of when down starts/ends so that we can
# TODO: handle toggling (only toggle once per down/up)
# TODO: clear activated state on rebind (i.e. state is per data, not per view)
# TODO: per the above, need to pass this as event back so it can propagate?
# TODO: There are some issues with dragging due to how godot attempts to keep controls focused
# TODO: when the mouse is held, see: https://github.com/godotengine/godot/issues/20881
# TODO: for now, don't do dragging stuff I guess
func _input(event):
	if not hovered:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT:
			activated = !activated
			event.pressed = false
			emit_signal("note_activated", note_data)
			#if activated:
			#	emit_signal("note_activated", note_data)
				# emit_signal("note_activated", measure, octave, pitch, time)
			change_draw_state()

func _on_TitleBackground_gui_input(event):
	pass

func comp_offsets(a, b, epsilon):
	return abs(a - b) <= epsilon

var played_timer = null
func _on_note_playback(n):
	var offset = n["start_offset"]
	# we need to convert our note's time to an offset that is comparable to the above
	var our_offset = (Globals.measure_time() * measure) + (time * Globals.sixteenthNoteTPQ())
	
	var offsets_match = comp_offsets(offset, our_offset, 0.01)
	
	if offsets_match and n["octave"] == note_data.octave() and n["key"] == note_data.key():
		played = true
		change_draw_state()
		
		played_timer = Timer.new()
		add_child(played_timer)
		played_timer.one_shot = true
		played_timer.connect("timeout", self, "_on_played_timer_timeout")
		played_timer.start(0.25)
		print("_on_note_playback started timer")

func _on_played_timer_timeout():
	played = false
	change_draw_state()
	print("_on_note_playback timer finished")
	remove_child(played_timer)

var cached_num_times = null
func _on_playback_time(indexedTimeOffset, indexedTime):
	if cached_num_times == null:
		cached_num_times = Globals.get_sizeconstants_numtimes()
	played_time = indexedTime == ((measure * cached_num_times) + time)
	if played_time:
		$Stroke.color = Color.green
	else:
		$Stroke.color = Color.black
