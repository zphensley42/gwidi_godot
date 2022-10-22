extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
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
