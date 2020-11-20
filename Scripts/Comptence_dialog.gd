extends AcceptDialog

func display_comp(comp):
	get_node(".").window_title = comp
	get_node("VBoxContainer/Description").bbcode_text = Json_reader.comps_data[comp]
	
	get_node(".").popup_centered()
	
func _on_Description_meta_clicked(meta):
	display_comp(meta)
