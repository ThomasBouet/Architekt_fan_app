extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_label().add_font_override("font", load("res://Fonts/Text_font.tres"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
