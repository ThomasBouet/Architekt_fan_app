extends Control


var Description_visible = false

func init(formule):
	get_node("Front/TextureButton/Nom").text = formule
	var form_split = Json_reader.forms_data[formule][3].split("Améliorations : ")
	get_node("Back/Info_Holder/Infos/Description").bbcode_text = form_split[0]
	get_node("Back/Info_Holder/Infos/HBoxContainer/Cout").text = "Cout : " + Json_reader.forms_data[formule][0]
	get_node("Back/Info_Holder/Infos/HBoxContainer/Portee").text = "Portée : " + Json_reader.forms_data[formule][1]
	get_node("Back/Info_Holder/Infos/HBoxContainer/Cible").text = "Cible : " + Json_reader.forms_data[formule][2]
	get_node("Back/Info_Holder/Infos/Amélioration").text = form_split[1] if form_split.size() > 1 else ""
	get_node("Back/Info_Holder/Infos/Amélio").visible = form_split.size() > 1
#	print(formule, form_split[1] + "1" if form_split.size() > 1 else form_split[0] + "0")
	return self
	
func _on_TextureButton_pressed():
	Description_visible = !Description_visible
	get_node("Back").visible = Description_visible
	
func _on_Description_meta_clicked(meta):
	get_node("Competence_Dialog").display_comp(meta)
