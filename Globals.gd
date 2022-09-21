extends Node

# old
const block_width = 80
const block_height = 40

# new
const note_width = 80
const note_height = 40
const measure_title_width = 80
const octave_title_height = 20

# per measure
const num_pitches = 8
const num_times = 16
const num_octaves = 3

static func octave_height():
	return num_pitches * note_height

static func measure_width():
	return num_times * note_width
