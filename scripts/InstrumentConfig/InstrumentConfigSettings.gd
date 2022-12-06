extends Control

var Item = load("res://scenes/InstrumentConfig/InstrumentConfigItem.tscn")

var config_options = null

# Control loading of settings from Gwidi
# Control hookup of buttons from popups to gwidi options
# Control layout / creation of items for each setting in the gwidi options

# Called when the node enters the scene tree for the first time.
func _ready():
	config_options = Gwidi_Options.new()
	
	InputRetrieval.register_parent(self)
	
	var popup = get_node("ConfigPopup")
	popup.popup_centered()
	
	load_config()

func save_config():
	# TODO: Run through all of the children and write out the config json that matches
	pass

func load_config():
	# TODO: Run through the config jsons we have and convert to config GUI options
	var cfg = config_options.instrumentConfig()
	for instrName in cfg:
		do_add_instrument(instrName)
		

func do_add_instrument(value):
	if value == null:
		return
	
	var list = get_node("ConfigPopup/Margin/MarginVBox/ScrollContainer/ConfigList")
	var list_add_button = get_node("ConfigPopup/Margin/MarginVBox/ScrollContainer/ConfigList/AddItemButton")
	
	var instrumentItem = Item.instance()
	instrumentItem.setup(value)
	list.add_child(instrumentItem)
	list.move_child(list_add_button, list.get_child_count())

func _on_add_instrument_pressed():
	var cb = funcref(self, "do_add_instrument")
	InputRetrieval.get_input(cb)
