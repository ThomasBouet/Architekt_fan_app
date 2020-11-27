extends Control


var Description_visible = false

func init(comp):
	get_node("TextureButton/Nom").text = comp
	get_node("Description").bbcode_text = Json_reader.comps_data[comp]
	return self
	
func resize_self():
	if Description_visible:
		get_node(".").rect_min_size = Vector2(get_node("ColorRect").rect_size.x, get_node("ColorRect").rect_size.y + get_node("Description").rect_size.y)
	else:
		get_node(".").rect_min_size = get_node("ColorRect").rect_size
	
func _on_TextureButton_pressed():
	Description_visible = !Description_visible
	get_node("Description").visible = Description_visible
	resize_self()
	
func _on_Description_meta_clicked(meta):
	get_node("Competence_Dialog").display_comp(meta)
