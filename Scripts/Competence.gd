extends VBoxContainer


var Description_visible = false

func init(comp):
	get_node("Front/TextureButton/Nom").text = comp
	get_node("Back/Info_Holder/Description").bbcode_text = Json_reader.comps_data[comp]
	return self
	
func _on_TextureButton_pressed():
	Description_visible = !Description_visible
	get_node("Back").visible = Description_visible

func _on_Description_meta_clicked(meta):
	get_node("Competence_Dialog").display_comp(meta)
