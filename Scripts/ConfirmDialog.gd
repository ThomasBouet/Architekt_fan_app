extends ConfirmationDialog


func _ready():
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_cancel().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_label().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_cancel().text = "Annuler"

func show_dialog(title, message):
	get_node(".").window_title = title
	get_node("RichTextLabel").text = message
	popup_centered()
	
