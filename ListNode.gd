extends Node2D

var is_visible = false
var data_pos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(p, dp):
	if data_pos != null and data_pos == dp:
		return
	data_pos = dp
	position = p
	$Background.margin_right = node_width()
	$Background.margin_bottom = node_height()
	$Background.color = Color(randf(), randf(), randf())
	
	$VisNotifier.rect.size.x = node_width()
	$VisNotifier.rect.size.y = node_height()
	
	$Title.margin_right = node_width()
	$Title.margin_bottom = node_height()

func node_width():
	return 400

func node_height():
	return 200

func bind_data(data):
	$Title.text = data


func _on_VisNotifier_screen_entered():
	is_visible = true


func _on_VisNotifier_screen_exited():
	is_visible = false

func is_visible_in_screen():
	return is_visible_in_tree() and is_visible
