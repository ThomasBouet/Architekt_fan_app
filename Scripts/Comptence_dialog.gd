extends AcceptDialog

func display_comp(comp):
	var json_file = File.new()
	json_file.open("res://competences.json", File.READ)
	var comp_data = JSON.parse(json_file.get_as_text()).result
	json_file.close()
	
	get_node(".").window_title = comp
	get_node("VBoxContainer/Description").bbcode_text = comp_data[comp]
	
	get_node(".").popup_centered()
	
func _on_Description_meta_clicked(meta):
	display_comp(meta)
