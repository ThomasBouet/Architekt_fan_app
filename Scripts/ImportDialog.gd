extends ConfirmationDialog


func _ready():
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_cancel().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_label().add_font_override("font", load("res://Fonts/Text_font.tres"))
