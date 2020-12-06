extends AcceptDialog


func _ready():
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_label().add_font_override("font", load("res://Fonts/Text_font.tres"))

func show_dialog(title, message):
	get_ok().text = "OK"
	get_node(".").window_title = title
	get_node("RichTextLabel").text = message
	popup_centered()
