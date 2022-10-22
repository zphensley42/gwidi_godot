extends Node

var assigned_data = null
var playback = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func data_playback_tick(time):
	print("data_playback_tick(" + str(time) + ")")
	# Now, we need to convert this time to a scroll offset in order to move the 
	# measures at the same rate as the playback
	

func playback_play():
	if playback != null:
		# For now, update our playback here since changes after-the-fact are not represented
		# by the TickHandler's tick map, which is only built when assigned data directly
		# TODO: Determine a better time / way to translate this stuff to the tick handler's tickMap
		# TODO: for now, it's fine but slow for big songs
		# TODO: Perhaps just find a way to use gui data directly instead of the tick wrapper types?
		
		# 0 = lowest, 1 = highest, 2 = most
		playback.assignData(assigned_data, 1)
		playback.play()

func playback_pause():
	if playback != null:
		playback.pause()

# TODO: Hook this up to GUI data, not just from the import
func assign_data(d):
	assigned_data = d
	playback = Gwidi_Gui_Playback.new()
	playback.assignInstrument("harp")

	var cb = funcref(self,'data_playback_tick')
	playback.assignTickCallbackFn(cb)

func get_assigned_data():
	return assigned_data

