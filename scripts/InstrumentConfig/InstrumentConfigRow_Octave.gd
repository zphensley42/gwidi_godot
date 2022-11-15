extends HBoxContainer

var Row_KeyItem = load("res://scenes/InstrumentConfig/InstrumentConfigRow_Key.tscn")

var octave_num = 0

func setup(num):
	octave_num = num
	get_node("Label").text = "Octave " + str(octave_num)

func our_child_pos():
	for i in range(self.get_parent().get_child_count()):
		var c = self.get_parent().get_child(i)
		if c == self:
			return i
	return -1

var added_offset = 0
func _on_add_key_pressed():
	var our_pos = our_child_pos()
	if our_pos == -1:
		print("Failed to retrieve our position for adding a key!")
		return
		
	var keyItem = Row_KeyItem.instance()
	self.get_parent().add_child(keyItem)
	
	# TODO: Need to make sure this keyItem is placed below ourselves in the list
	self.get_parent().move_child(keyItem, our_pos + 1 + added_offset)
	added_offset += 1


func _on_octave_remove_pressed():
	self.get_parent().remove_child(self)
	self.queue_free()
