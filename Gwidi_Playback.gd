extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	GwidiDataManager.connect("playback_ended", self, "_on_playback_ended")
	pass # Replace with function body.

# 0 = stopped, 1 = play, 2 == pause
var play_state = 0
func _on_Button_Play_pressed():
	# TODO: When playing, make sure that our GUI data is reflected in the GwidiDataManager for playback
	if play_state == 0 or play_state == 2:
		play_state = 1
		GwidiDataManager.playback_play()
	elif play_state == 1:
		GwidiDataManager.playback_pause()
		play_state = 2
	
	update_play_button()

func update_play_button():
	if play_state == 1:
		get_node("../UiCanvasLayer/Button_Play").text = "Pause"
	elif play_state == 0 or play_state == 2:
		get_node("../UiCanvasLayer/Button_Play").text = "Play"
	
	get_node("/root/Main2/UiCanvasLayer/Button_Add_Measure").disabled = (play_state == 1)


func _on_Button_Stop_pressed():
	GwidiDataManager.playback_stop()

func _on_playback_ended():
	play_state = 0
	update_play_button()


func _on_Button_Clear_pressed():
	# TODO: Clear everything thing and start anew
	pass # Replace with function body.


func _on_Button_Add_Measure_pressed():
	# TODO: Probably disable this if we are playing (it does work, but there are some thread locking concerns)
	if play_state != 1:
		var n = get_node("/root/Main2/MeasureRecyclerListH")
		n.addMeasure()
