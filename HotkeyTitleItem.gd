extends Panel


var style = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#style.set_bg_color(Color("102b57"))
	#self.add_stylebox_override("panel", style)
	
	var parent_size = get_parent().margin_right
	
	# self.margin_right = 580
	# self.set_size(Vector2(580, 48))
	pass

func _process(delta):
	self.margin_right = 580
