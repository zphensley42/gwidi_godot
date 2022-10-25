extends Node

signal playback_scroll

var assigned_data = null
var playback = null

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
	var measureTime = Globals.measure_time()
	var timeInMeasure = fmod(time, measureTime)
	var pctOfMeasure = timeInMeasure / measureTime
	var numMeasureInTime = floor(time / measureTime)
	
	var measureWidth = Globals.measure_width()
	var pctOfMeasureInWidth = measureWidth * pctOfMeasure
	var totalScrollInWidth = pctOfMeasureInWidth + (numMeasureInTime * measureWidth)
	print("data_playback_tick(" + str(time) + ")")
	print("\tmeasureTime: " + str(measureTime))
	print("\tpctOfMeasure: " + str(pctOfMeasure))
	print("\tmeasureWidth: " + str(measureWidth))
	print("\tpctOfMeasureInWidth: " + str(pctOfMeasureInWidth))
	
	var indexedTime = floor(time / Globals.sixteenthNoteTPQ())
	var numTitles = floor(indexedTime / Globals.get_sizeconstants_numtimes()) + 1	# +1 for the starting title
	var indexedTimeOffset = (indexedTime * Globals.note_width) + (numTitles * Globals.measure_title_width)
	
	
	# So, THIS WORKS --- BUTTTTT
	# It doesn't take into account titles or anything else in the horizontal scroll pane
	# We can either:
	# 1 - add additional logic to 'skip' over the width of titles in the display
	#   - by adding the title width each time we move forward in measure index
	# 2 - determine scroll position by the indexed note instead
	#   - this could work to help display which 'time' is being played currently
	#call_deferred("emit_signal", "playback_scroll", totalScrollInWidth) 
	
	
	# THIS WOKRED :)
	call_deferred("emit_signal", "playback_scroll", indexedTimeOffset, indexedTime) 
	

func playback_play():
	if playback != null:
		# For now, update our playback here since changes after-the-fact are not represented
		# by the TickHandler's tick map, which is only built when assigned data directly
		# TODO: Determine a better time / way to translate this stuff to the tick handler's tickMap
		# TODO: for now, it's fine but slow for big songs
		# TODO: Perhaps just find a way to use gui data directly instead of the tick wrapper types?
		
		# 0 = lowest, 1 = highest, 2 = most
		playback.assignData(assigned_data, 1)
		
		# required after we assign data
		var cb = funcref(self,'data_playback_tick')
		playback.assignTickCallbackFn(cb)
		
		# for testing
		playback.setRealInput(true)
		
		
		playback.play()

func playback_pause():
	if playback != null:
		playback.pause()

# TODO: Hook this up to GUI data, not just from the import
func assign_data(d):
	assigned_data = d
	playback = Gwidi_Gui_Playback.new()
	playback.assignInstrument("harp")

func get_assigned_data():
	return assigned_data

