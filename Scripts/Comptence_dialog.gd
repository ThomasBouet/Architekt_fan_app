extends AcceptDialog

func _ready():
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_label().add_font_override("font", load("res://Fonts/Text_font.tres"))

func display_comp(comp):
	get_ok().add_font_override("font", load("res://Fonts/Text_font.tres"))
	get_node(".").window_title = comp
	get_node("VBoxContainer/Description").bbcode_text = Json_reader.comps_data[comp]
	get_node(".").popup_centered()
	
func _on_Description_meta_clicked(meta):
	display_comp(meta)
