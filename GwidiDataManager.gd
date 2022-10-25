extends Node

signal playback_scroll
signal playback_note
signal playback_ended

var assigned_data = null
var playback = null
var sample_manager = null

var playback_lock = Mutex.new()
func assign_playback(p):
	playback_lock.lock()
	playback = p
	playback_lock.unlock()

func clear_playback():
	playback_lock.lock()
	playback = null
	playback_lock.unlock()

func call_playback_func(f):
	if !f.is_valid():
		return
	playback_lock.lock()
	f.call_func()
	playback_lock.unlock()

func register_sample_manager(sm):
	sample_manager = sm

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEventRegister.register_data_manager(self)

func data_playback_tick(time):
	# Now, we need to convert this time to a scroll offset in order to move the 
	# measures at the same rate as the playback 
	# we do this by
	# 1 - convert the width of the measure into time
	# 2 - convert the time input to a percentage of this width
	# 3 - finally, get the real value of the width from this percentage to use as scroll_x
	#var measureTime = Globals.measure_time()
	#var timeInMeasure = fmod(time, measureTime)
	#var pctOfMeasure = timeInMeasure / measureTime
	#var numMeasureInTime = floor(time / measureTime)
	
	#var measureWidth = Globals.measure_width()
	#var pctOfMeasureInWidth = measureWidth * pctOfMeasure
	#var totalScrollInWidth = pctOfMeasureInWidth + (numMeasureInTime * measureWidth)
	#print("data_playback_tick(" + str(time) + ")")
	#print("\tmeasureTime: " + str(measureTime))
	#print("\tpctOfMeasure: " + str(pctOfMeasure))
	#print("\tmeasureWidth: " + str(measureWidth))
	#print("\tpctOfMeasureInWidth: " + str(pctOfMeasureInWidth))
	
	# So, THIS WORKS --- BUTTTTT
	# It doesn't take into account titles or anything else in the horizontal scroll pane
	# We can either:
	# 1 - add additional logic to 'skip' over the width of titles in the display
	#   - by adding the title width each time we move forward in measure index
	# 2 - determine scroll position by the indexed note instead
	#   - this could work to help display which 'time' is being played currently
	#call_deferred("emit_signal", "playback_scroll", totalScrollInWidth) 
	
	var indexedTime = floor(time / Globals.sixteenthNoteTPQ())
	var numTitles = floor(indexedTime / Globals.get_sizeconstants_numtimes()) + 1	# +1 for the starting title
	var indexedTimeOffset = (indexedTime * Globals.note_width) + (numTitles * Globals.measure_title_width)
	
	
	# THIS WORKED :)
	call_deferred("emit_signal", "playback_scroll", indexedTimeOffset, indexedTime)

# TODO: There is an issue with our first delay
# TODO: If there is a bunch of silence at the beginning, the notes we get back
# TODO: seem to ignore it, instead 'flooring' the first note even if we aren't at that time yet
func notes_playback(notes):
	print("notes_playback, size: " + str(notes.size()))
	if(sample_manager):
		for note in notes:
			sample_manager.play_sample_for_note(note)
			
			# emit the note we are playing to update its view on screen
			# a hack to make this quicker is to just emit note data that each note
			# listens for and have the notes treat it as a temporary state
			# the notes can draw the temporary state per their own timers
			# before clearing it
			call_deferred("emit_signal", "playback_note", note)

func playback_ended():
	print("playback ended")
	# clear_playback()
	call_deferred("emit_signal", "playback_scroll", 0, 0)
	call_deferred("emit_signal", "playback_ended")

func playback_play():
	# TODO: This works but it is slow, see my comments below
	# In general, having to assign this stuff on play makes it feel even slower
	# because we end up waiting here until it is complete to actually begin playing back
	#var pb = Gwidi_Gui_Playback.new()
	#pb.assignInstrument("harp")
	#assign_playback(pb)
	# IMPORTANT TODO: IT BREAKS PAUSE FUNCTIONALITY to reset this every time we play
	# IMPORTANT TODO: Need to fix this inefficiency in order to have a function play/pause as expected!!!
	
	if playback != null:
		# For now, update our playback here since changes after-the-fact are not represented
		# by the TickHandler's tick map, which is only built when assigned data directly
		# TODO: Determine a better time / way to translate this stuff to the tick handler's tickMap
		# TODO: for now, it's fine but slow for big songs
		# TODO: Perhaps just find a way to use gui data directly instead of the tick wrapper types?
		
		# 0 = lowest, 1 = highest, 2 = most
		playback.assignData(assigned_data, 1)
		
		# required after we assign data
		var cb = funcref(self, 'data_playback_tick')
		playback.assignTickCallbackFn(cb)
		
		var play_cb = funcref(self, 'notes_playback')
		playback.assignPlayCallbackFn(play_cb)
		
		var ended_cb = funcref(self, 'playback_ended')
		playback.assignPlayEndedFn(ended_cb)
		
		# for testing
		playback.setRealInput(false)
		
		var f = funcref(playback, "play")
		call_playback_func(f)

func playback_pause():
	var f = funcref(playback, "pause")
	call_playback_func(f)

func playback_stop():
	var f = funcref(playback, "stop")
	call_playback_func(f)

# TODO: Hook this up to GUI data, not just from the import
func assign_data(d):
	assigned_data = d
	
	var pb = Gwidi_Gui_Playback.new()
	pb.assignInstrument("harp")
	assign_playback(pb)

func get_assigned_data():
	return assigned_data

