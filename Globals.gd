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
# TODO: These values should be based on instrument settings I guess?
const num_pitches = 8
const num_times = 16
const num_octaves = 3


# time-indexing
const tempo = 60.0

static func tempo_to_tpq():
	return 60.0 / tempo	# return seconds per quarter note

static func octave_height():
	return num_pitches * note_height

static func measure_width():
	return num_times * note_width
