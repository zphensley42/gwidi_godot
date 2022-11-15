extends PanelContainer

var Row_OctaveItem = load("res://scenes/InstrumentConfig/InstrumentConfigRow_Octave.tscn")

# TODO: Probably need an expanded and unexpanded view of the items because they show so much
# TODO: Buttons on unexpanded should expand and vice-versa
# Control layout of the item
# Hook item buttons to gwidi calls for creating / updating the config


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(instrumentName):
	get_node("Vert/Row_InstrumentTitle/Label").text = instrumentName

func do_add_octave(value):
	if value != null:
		# TODO: Need to validate the value provided
		var octaveItem = Row_OctaveItem.instance()
		octaveItem.setup(value)
		get_node("Vert").add_child(octaveItem)

func _on_octave_add_pressed():
	var cb = funcref(self, "do_add_octave")
	InputRetrieval.get_input(cb)


func _on_instrument_remove_pressed():
	self.get_parent().remove_child(self)
	self.queue_free()
