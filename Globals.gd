extends Node

# old
const block_width = 80
const block_height = 40

# new
const note_width = 70
const note_height = 30
const measure_title_width = 80
const octave_title_height = 20

# per measure
# TODO: These values should be based on instrument settings I guess?
var num_pitches = 8
var num_times = 16
var num_octaves = 3

# Build dictionary of size values to use in layout
# [
#		octave: num, num_times, num_pitches,
#		octave: num_times, num_pitches,
#		octave: num_times, num_pitches
# ]

# time-indexing
var tempo = 60.0

var size_constants = []

func calc_size_constants(data):
	size_constants.clear()
	
	var measures = data.getMeasures()
	tempo = data.tempo()
	
	var octaves = measures[0].getOctaves()
	num_octaves = octaves.size()
	for o in octaves:
		var times = o.getTimes()
		var size_constant_octave = {
			"num": o.num(),
			"num_times": times.size(),
			"num_pitches": times[times.keys()[0]].size()
		}
		size_constants.append(size_constant_octave)


func octave_height(num):
	return size_constants[num]["num_pitches"] * note_height

# This is confusing to follow, but the key is that we need to reverse the sizes/offsets to match
# the y-reverse of the display
# TODO: This should be done more generically to work with different #s of octaves per instrument settings
func octave_y_offset(num):
	if num == 0:
		return octave_height(2) + octave_height(1)
	elif num == 1:
		return octave_height(2)
	elif num == 2:
		return 0
	else:
		return 0

func measure_width():
	# for now, just assume each measure/octave has the same timing
	return size_constants[0]["num_times"] * note_width

# yeah yeah, this generic conversion makes no sense directly using sixteenthNotes b/c it implies num_times is 16
# oh well, for now
func measure_time():
	return size_constants[0]["num_times"] * sixteenthNoteTPQ() 

func sixteenthNoteTPQ():
	return 15 / tempo

func get_sizeconstants_numtimes():
	return size_constants[0]["num_times"]

#static func octave_height():
#	return num_pitches * note_height

#static func measure_width():
#	return num_times * note_width
