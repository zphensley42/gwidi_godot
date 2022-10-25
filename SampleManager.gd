extends Node

var samples = {
	"piano": {
		"octave_0;key_1": {
			"res": "res://samples/piano/c4.mp3",
			"player": null
		},
		"octave_1;key_1": {
			"res": "res://samples/piano/c5.mp3",
			"player": null
		},
		"octave_2;key_1": {
			"res": "res://samples/piano/c6.mp3",
			"player": null
		},
		"octave_2;key_8": {
			"res": "res://samples/piano/c7.mp3",
			"player": null
		},
		"octave_0;key_2": {
			"res": "res://samples/piano/d4.mp3",
			"player": null
		},
		"octave_1;key_2": {
			"res": "res://samples/piano/d5.mp3",
			"player": null
		},
		"octave_2;key_2": {
			"res": "res://samples/piano/d6.mp3",
			"player": null
		},
		"octave_0;key_3": {
			"res": "res://samples/piano/e4.mp3",
			"player": null
		},
		"octave_1;key_3": {
			"res": "res://samples/piano/e5.mp3",
			"player": null
		},
		"octave_2;key_3": {
			"res": "res://samples/piano/e6.mp3",
			"player": null
		},
		"octave_0;key_4": {
			"res": "res://samples/piano/f4.mp3",
			"player": null
		},
		"octave_1;key_4": {
			"res": "res://samples/piano/f5.mp3",
			"player": null
		},
		"octave_2;key_4": {
			"res": "res://samples/piano/f6.mp3",
			"player": null
		},
		"octave_0;key_5": {
			"res": "res://samples/piano/g4.mp3",
			"player": null
		},
		"octave_1;key_5": {
			"res": "res://samples/piano/g5.mp3",
			"player": null
		},
		"octave_2;key_5": {
			"res": "res://samples/piano/g6.mp3",
			"player": null
		},
		"octave_0;key_6": {
			"res": "res://samples/piano/a4.mp3",
			"player": null
		},
		"octave_1;key_6": {
			"res": "res://samples/piano/a5.mp3",
			"player": null
		},
		"octave_2;key_6": {
			"res": "res://samples/piano/a6.mp3",
			"player": null
		},
		"octave_0;key_7": {
			"res": "res://samples/piano/b4.mp3",
			"player": null
		},
		"octave_1;key_7": {
			"res": "res://samples/piano/b5.mp3",
			"player": null
		},
		"octave_2;key_7": {
			"res": "res://samples/piano/b6.mp3",
			"player": null
		},
	}
}


var loader = AudioLoader.new()

func load_stream(sample):
	var stream = loader.loadfile(sample)
	stream.loop = false
	return stream

func preload_samples():
	for key in samples["piano"]:
		var stream = load_stream(samples["piano"][key]["res"])
		samples["piano"][key]["player"] = AudioStreamPlayer.new()
		samples["piano"][key]["player"].name = key
		samples["piano"][key]["player"].stream = stream
		add_child(samples["piano"][key]["player"])
		

# TODO: Is there an issue with playing a sample over top of another? probably
# TODO: probably need multiple samples instantiated instead of this
func play_sample_for_note(note):
	var sample_key = "octave_" + str(note["octave"]) + ";key_" + note["key"]
	var player = samples["piano"][sample_key]["player"]
	
	print("--play_sample_for_note--")
	print("\tsample_key: " + sample_key)
	
	player.play()


# Called when the node enters the scene tree for the first time.
func _ready():
	preload_samples()
	GwidiDataManager.register_sample_manager(self)

